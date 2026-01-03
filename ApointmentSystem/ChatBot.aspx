<%@ Page Title="ChatBot" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="ChatBot.aspx.cs"
    Inherits="AppointmentSystem.ChatBot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container" style="max-width: 900px;">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h2 class="m-0">Somcare Health ChatBot</h2>
            <button type="button" class="btn btn-success" id="btnStart">Start Chat</button>
        </div>

        <div class="alert alert-info" id="startHint" style="display:none;">
            Click <b>Start Chat</b> to begin, then you can type.
        </div>

        <div class="card shadow-sm">
            <div class="card-body" style="padding: 0;">
                <div id="messages" class="p-3" style="height: 420px; overflow-y: auto; background: #f8f9fa;"></div>

                <div class="border-top p-3">
                    <div class="input-group">
                        <input type="text" id="txtMessage" class="form-control" placeholder="Type your message..." autocomplete="off" disabled />
                        <button type="button" class="btn btn-primary" id="btnSend" disabled>Send</button>
                    </div>
                    <small class="text-muted d-block mt-2">Tip: type <b>1</b> for health questions, <b>2</b> to book an appointment, <b>3</b> to exit.</small>
                </div>
            </div>
        </div>
    </div>

    <script>
        let chatActive = false;
        let inactivityTimer = null;
        const inactivityMs = 60 * 1000;

        function setChatActive(active) {
            chatActive = active;
            document.getElementById("txtMessage").disabled = !active;
            document.getElementById("btnSend").disabled = !active;

            const hint = document.getElementById("startHint");
            if (active) {
                hint.style.display = "none";
                resetInactivityTimer();
            } else {
                hint.style.display = "block";
                clearInactivityTimer();
            }
        }

        function clearInactivityTimer() {
            if (inactivityTimer) {
                clearTimeout(inactivityTimer);
                inactivityTimer = null;
            }
        }

        function resetInactivityTimer() {
            if (!chatActive) return;
            clearInactivityTimer();
            inactivityTimer = setTimeout(() => {
                setChatActive(false);
                callServiceSilent("__close__");
                addMsg("Bot", "⏳ Chat closed due to inactivity. Click <b>Start Chat</b> to begin again.");
            }, inactivityMs);
        }

        function escapeHtml(str) {
            return String(str)
                .replaceAll("&", "&amp;")
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll('"', "&quot;")
                .replaceAll("'", "&#039;");
        }

        function scrollToBottom() {
            const box = document.getElementById("messages");
            box.scrollTop = box.scrollHeight;
        }

        function addMsg(sender, htmlText) {
            const safeSender = escapeHtml(sender);
            const messageHtml = `
                <div class="mb-2">
                    <div class="small text-muted">${safeSender}</div>
                    <div class="p-2 rounded" style="background: #ffffff; border: 1px solid #e9ecef;">${htmlText}</div>
                </div>`;

            document.getElementById("messages").insertAdjacentHTML("beforeend", messageHtml);
            scrollToBottom();
        }

        async function sendMessage() {
            if (!chatActive) return;
            const input = document.getElementById("txtMessage");
            const msg = (input.value || "").trim();
            if (!msg) return;

            if (msg.toLowerCase() === "clear") {
                document.getElementById("messages").innerHTML = "";
                input.value = "";
                resetInactivityTimer();
                await callServiceSilent("clear");
                return;
            }

            addMsg("You", escapeHtml(msg));
            input.value = "";
            resetInactivityTimer();

            try {
                await callService(msg);
            } catch (e) {
                addMsg("Bot", "⚠️ Network error. Please try again.");
            }
        }

        async function callService(message) {
            const res = await fetch("ChatBotService.asmx/Chat", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ message: message })
            });

            if (!res.ok) {
                addMsg("Bot", "⚠️ Server error calling chatbot service.");
                return;
            }

            const data = await res.json();
            addMsg("Bot", data.d);
            resetInactivityTimer();
        }

        async function callServiceSilent(message) {
            try {
                await fetch("ChatBotService.asmx/Chat", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=utf-8" },
                    body: JSON.stringify({ message: message })
                });
            } catch (e) {
                // ignore
            }
        }

        async function startChat() {
            document.getElementById("messages").innerHTML = "";
            setChatActive(true);
            document.getElementById("txtMessage").focus();
            await callService("__start__");
        }

        document.getElementById("btnSend").addEventListener("click", sendMessage);
        document.getElementById("btnStart").addEventListener("click", startChat);
        document.getElementById("txtMessage").addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                e.preventDefault();
                sendMessage();
            }
        });

        setChatActive(false);
    </script>

</asp:Content>
