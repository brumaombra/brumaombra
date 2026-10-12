---
name: guide-writing-style
description: 'Writing style for technical how-to guides, tutorials, and step-by-step walkthroughs. Use when drafting, rewriting, or reviewing guide or tutorial prose. For general blog posts, use blog-writing-style instead.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Technical Guide Writing Style

Write like a technically capable friend guiding the reader through a real project: curious about the problem, patient with unfamiliar concepts, specific about each action, honest about limits, and quietly pleased when the final test works.

This skill covers prose only. Frontmatter, filenames, routes, images, MDC components, link syntax, SEO metadata, schema, translation, and technical correctness belong to other steps.

Keep the warmth, but never at the cost of correct grammar or technically defensible wording. If source material has mistakes or unsupported claims, don't copy them.

Examples below are shown as **Do** / **Not** pairs. They illustrate the principle; don't reuse their wording.

## Voice

**Pronouns carry meaning.** The writer and reader are solving a problem together. Use `we` and `let's` for the shared journey, `you` to make the reader's action unmistakable, and `I` only for a real preference, local example, or labeled observation.

- **Do:** We will first give the device a stable address, then test that the other devices can still reach it.
- **Not:** The user must now execute a series of network configuration operations.

- **Do:** Open the app and check the connection state before trusting the VPN with sensitive traffic.
- **Not:** One should proceed to the application interface and ascertain the operational status of the tunnel.

**Never fabricate the first person.** No invented experiments, credentials, or promises that the reader's setup will behave like yours.

- **Do:** In my case, the router did not let me change the service setting, so I configured it on each device instead.
- **Not:** After testing every router on the market, I can guarantee that this is the best approach.

**Contractions and ordinary words.** They make the voice sound spoken without making it sloppy. Prefer familiar verbs to corporate or academic abstractions, and explain serious subjects without assuming the reader is an expert.

- **Do:** If the page still fails, change one setting and test again.
- **Not:** In the event that the webpage continues to exhibit non-functional behavior, modify multiple parameters accordingly.

## Openings

Start with a concern the reader actually has: surveillance, inconvenience, risk, a repetitive task, or a device they already use. Follow it with an answerable promise that names what the guide will set up and how it will be verified. Never open with an empty claim about how important the topic is.

- **Do:** Are you tired of entering the same command every time the service restarts? In this guide, we will turn that manual task into a repeatable setup and check that it survives a reboot.
- **Not:** In today's fast-paced digital world, automation is becoming increasingly important for everyone.

- **Do:** Maybe the device works perfectly on your desk but fails as soon as it joins another network. That difference is useful evidence, and we will use it to find the cause.
- **Not:** Network problems are complex. This ultimate guide contains everything you need to know about them.

## Explain before instructing

Give a reason before an action. Define specialist terms at first use, keeping the definition short and practical. Use an analogy only when it genuinely reduces confusion.

- **Do:** A static address is a fixed address that other devices can keep using to find the device. A changing assignment could make the gateway disappear, so we will reserve one before routing traffic through it.
- **Not:** Configure a static IP because it is required by the architecture.

- **Do:** Think of DNS as the Internet's phone book: it turns a name such as `example.com` into an address a device can contact.
- **Not:** DNS is basically magic that finds websites for you.

## Step rhythm

Keep the reader moving with a repeatable rhythm: name the situation or goal → explain why the next action matters → give the action in concrete language → state what the reader should see or test → say what to do if the result differs. Name the actual device, setting, protocol, symptom, expected output, and next decision instead of giving vague advice.

Use transitions that show where the reader is: `At this point`, `Once that works`, `Before moving on`, `For this reason`, `However`, `Before celebrating`.

- **Do:** The service is running, but traffic from the rest of the network still stops at the gateway. We now need forwarding and translation so the gateway can pass that traffic through the connection. After applying the rules, test the route from a second device instead of assuming the gateway is working.
- **Not:** Enable forwarding. Add NAT. Test it. Continue with the next configuration.

- **Do:** The installer is asking for an upstream DNS provider. Choose a temporary provider for now; we will replace it after the VPN tunnel is working.
- **Not:** Select the DNS provider and proceed through the wizard.

**Vary sentence length.** Alternate longer explanatory sentences with short beats that land a point, build anticipation, or acknowledge a result. A run of only short sentences, or constant drama, is as tiring as a wall of long ones.

- **Do:** The first connection may take a little longer because the phone is creating its VPN profile. Give it a moment. Once the connected indicator appears, check the public IP address before browsing normally.
- **Not:** The connection may take longer. Wait. Check the indicator. Check the IP. Browse.

**Rhetorical questions** can voice the reader's next thought when a term or choice is unfamiliar. Answer them right away, and use them occasionally, not to open every paragraph.

- **Do:** "Why not leave the address dynamic?" Because another device needs to know where to find the gateway tomorrow, not only today.
- **Not:** You may be wondering about a number of important and interesting questions regarding WireGuard and its many benefits.

## Warmth without hype

Small reactions like `Okay`, `Great`, `Pretty useful, isn't it?`, or `Before celebrating`, an occasional light joke, or a friendly aside give the guide a human pulse. Place them around meaningful progress and keep the technical point at the center. No hype, sales language, forced slang, or exclamation-mark runs.

- **Do:** Great, the gateway can now reach the Internet through the connection. We still need to test another device, because the routed path is a separate part of the setup.
- **Not:** Great!!! Your network is now an unstoppable privacy fortress that no one can ever penetrate!

Reassure without talking down to the reader.

- **Do:** If you are not used to the terminal, this command may look intimidating. It only asks the system to display the current interface details.
- **Not:** Even beginners can effortlessly master this advanced enterprise-grade workflow.

## Honesty and certainty

Trust comes from stating what a tool does and doesn't do. Keep privacy distinct from anonymity, a working connection distinct from a secure configuration, and a likely result distinct from a guaranteed one. Never promise anonymity, perfect security, total protection, or universal compatibility.

- **Do:** A VPN can hide your public IP address from the websites you visit and encrypt the path to the VPN server. It does not stop tracking through accounts, cookies, browser fingerprints, or information you submit yourself.
- **Not:** A VPN makes you completely anonymous and protects everything you do online.

- **Do:** This configuration reduces exposure for devices using the gateway. It does not protect a device that uses another resolver or bypasses the gateway.
- **Not:** Once this is installed, every device is fully protected no matter how it connects.

Calibrate with `usually`, `may`, `often`, `in my case`, `depending on`, or `as a starting point` when the result depends on hardware, software version, network conditions, or configuration. Qualification isn't weakness; it tells the reader what to verify. Expected output should be framed as similar, not identical.

- **Do:** The command should return a response similar to the example below. Your interface name, address, and server may be different.
- **Not:** You will see exactly the output shown here.

- **Do:** A nearby server will usually be a sensible starting point, although distance, load, and network routing all affect the result.
- **Not:** The nearest server is always the fastest server.

## Troubleshooting

Stay calm and staged. Start with the simplest dependency, change one variable at a time, use each symptom as evidence to narrow the cause, and explain why the order matters. Never suggest disabling a protection just to make a test pass.

- **Do:** If the first connectivity check fails, check the device's gateway. If the gateway responds but the external address does not, inspect routing. If the external address works but a domain does not resolve, investigate name resolution.
- **Not:** If it does not work, restart everything, change all the settings, and try again.

- **Do:** Do not disable the protection merely to make the test green. Find out whether the failure comes from a captive portal, an unavailable server, or a local rule first.
- **Not:** Turn off the safety feature whenever it gets in the way.

## Warnings

Put warnings where the reader can act on them, state the consequence, and give the recovery path. Encourage saving the current state before a risky change. No theatrical danger language.

- **Do:** If you are connected over SSH, the address change may drop your session. Reconnect using the new address before continuing.
- **Not:** Warning!!! This command is extremely dangerous and could destroy everything!!!

- **Do:** Keep the access token private. Anyone who has it may be able to use the remaining account time, so do not include it in screenshots or support requests.
- **Not:** Share your account number freely because it is only a harmless identifier.

## Structure

A typical flow, adapted to the subject:

1. Introduce the problem and the result the reader can expect.
2. Define the important concept in plain language.
3. List what the reader needs.
4. Move through numbered stages.
5. Verify the result after each meaningful change.
6. Troubleshoot based on observed symptoms.
7. State limits and maintenance advice.
8. Recap the working setup and close warmly.

Each section should answer the question raised by the previous one. Headings should be clear and practical, naming the stage or symptom, never a keyword or a generic label.

- **Do:** `## 4. Test the route in stages` / `### If the check still shows a DNS leak`
- **Not:** `## Everything You Need to Know About the Best Network Solution` / `### More Troubleshooting Information`

**Emphasis.** Bold a product name, command, setting, protocol, or critical distinction only when it helps scanning. Don't bold every technical noun, capitalize for volume, or repeat the same keyword in every sentence.

- **Do:** Set the **gateway device** as the **default route**, then verify that name resolution still points to the intended **resolver**.
- **Not:** Set the **gateway device** as the **DEFAULT ROUTE** and make sure it uses the intended **NAME RESOLVER** for the **NETWORK**.

## Endings

Recap the verified result, give maintenance advice (updates, re-testing after changes), point to a related guide only when it truly helps, and sign off like a person, not a brochure. Keep it specific, not motivational.

- **Do:** Your device is now using the configured connection, and you have verified it instead of trusting an indicator alone. Keep the software updated, and repeat the check after a major network or service change. If you later want to extend the setup to more devices, the broader network guide is the natural next step.
- **Not:** In conclusion, this amazing solution is the best choice for everyone. Start your journey today and unlock the future!

## Conversational moves

Occasional tools, not catchphrases. Don't reuse the same one in every section; the voice should feel like an attentive companion, not a template.

- `Okay, now let's ...` moves into the next action.
- `Wait, ...?` anticipates an unfamiliar term or surprising choice.
- `In my case, ...` separates a local example from a universal rule.
- `As you can see, ...` interprets a screenshot or command result.
- `Before celebrating, ...` introduces a final verification.
- `If you are not too technical, ...` translates a command or concept without talking down.
- `For this reason, ...` connects a problem to the next action.
- `So, that's it!` closes warmly, only once the guide has actually shown the result.

## Final check

Before delivering, confirm:

- The opening starts from a real reader concern or concrete situation.
- It sounds like one person talking to one reader; `we`, `you`, and `I` each do their job.
- Unfamiliar terms are explained before they become shorthand.
- Each major action has a reason and a verification step.
- Sentence length and pacing vary; asides and questions are warm and occasional.
- Privacy, security, compatibility, and performance claims are bounded, with no invented testing or certainty.
- Troubleshooting changes one variable at a time and uses symptoms as evidence.
- Warnings are placed where they're actionable and include a recovery path.
- The conclusion recaps, covers maintenance, and ends naturally.
- Generic AI phrasing, corporate filler, hype, and keyword repetition are gone.

The reader should finish feeling that the system is understandable and that they know what to check next.