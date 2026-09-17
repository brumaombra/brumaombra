---
name: guide-writing-style
description: 'Prose-only style for technical how-to guides and step-by-step walkthroughs. Produces warm, practical, technically honest instructions with plain-language explanations, varied rhythm, and extensive reader guidance.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Practical Technical Guide Writing Style

This skill controls prose only. It does not decide frontmatter, filenames, routes, images, MDC components, link syntax, SEO metadata, schema, translation, or technical correctness.

## Style in One Sentence

Sound like a technically capable friend guiding a reader through a real project: curious about the problem, patient with unfamiliar concepts, specific about each action, honest about limits, and quietly pleased when the final test works.

## What to Preserve

This style has these traits:

- **Inclusive viewpoint:** use `we` and `let's` for the shared journey, `you` for direct instructions, and `I` for a clearly marked preference or personal observation.
- **Conversational expertise:** explain serious technical subjects in ordinary language without pretending the reader is an expert.
- **Practical momentum:** introduce a reason, take one action, then check what happened before moving on.
- **Friendly asides:** use an occasional rhetorical question, small reaction, or light joke to make a long procedure feel human.
- **Concrete detail:** name the device, setting, protocol, symptom, expected output, and next decision rather than hiding behind vague advice.
- **Responsible caveats:** distinguish privacy from anonymity, a working connection from a secure configuration, and a likely result from a guaranteed one.
- **Warm closure:** recap the useful result, mention maintenance or limitations, point to a genuinely related guide, and end like a person rather than a brochure.

Capture the voice, not accidental grammar mistakes or unsupported claims from any source material. Keep the warmth while using correct grammar and technically defensible wording.

## Voice and Point of View

### Use an inclusive guide voice

The writer and reader are solving a problem together. `We` should describe the shared setup; `you` should make the reader's action unmistakable.

**DO**

> We will first give the device a stable address, then test that the other devices can still reach it.

**DON'T**

> The user must now execute a series of network configuration operations.

**DO**

> Open the app and check the connection state before trusting the VPN with sensitive traffic.

**DON'T**

> One should proceed to the application interface and ascertain the operational status of the tunnel.

### Use first person deliberately

Use `I` for a real preference, a local example, or a clearly labeled observation. Do not manufacture experiments or personal credentials.

**DO**

> In my case, the router did not let me change the service setting, so I configured it on each device instead.

**DON'T**

> After testing every router on the market, I can guarantee that this is the best approach.

**DO**

> I would start with a nearby server because it is a sensible baseline for latency.

**DON'T**

> I personally tested this on every network, so it will work exactly the same for you.

### Prefer contractions and ordinary words

Contractions make the voice sound spoken without making it sloppy. Choose familiar verbs over corporate or academic abstractions.

**DO**

> You don't need an account password. The service gives you a number instead.

**DON'T**

> The user is not required to possess conventional authentication credentials.

**DO**

> If the page still fails, change one setting and test again.

**DON'T**

> In the event that the webpage continues to exhibit non-functional behavior, modify multiple parameters accordingly.

## Openings: Begin With a Real Concern

This style often starts with questions about surveillance, inconvenience, risk, or a device the reader already uses. Follow the question with an answerable promise. Do not begin with empty importance claims.

**DO**

> Are you tired of entering the same command every time the service restarts? In this guide, we will turn that manual task into a repeatable setup and check that it survives a reboot.

**DON'T**

> In today's fast-paced digital world, automation is becoming increasingly important for everyone.

**DO**

> Your phone carries a surprising amount of personal information. We will set up the VPN, verify the public IP address, and then look at the settings that affect everyday use.

**DON'T**

> Privacy is more important than ever, and this revolutionary solution will completely transform your digital life.

**DO**

> Maybe the device works perfectly on your desk but fails as soon as it joins another network. That difference is useful evidence, and we will use it to find the cause.

**DON'T**

> Network problems are complex. This ultimate guide contains everything you need to know about them.

## Explain Before You Instruct

Give the reader a reason before an action. Define specialist terms at first use, then keep the definition short and practical. Use an analogy only when it genuinely reduces confusion.

**DO**

> A static address is a fixed address that other devices can keep using to find the device. A changing assignment could make the gateway disappear, so we will reserve one before routing traffic through it.

**DON'T**

> Configure a static IP because it is required by the architecture.

**DO**

> A kill switch blocks traffic when the VPN cannot maintain its tunnel. That can prevent an accidental fallback to ordinary Wi-Fi, although it may also interrupt local services.

**DON'T**

> The kill switch is a revolutionary security feature that makes your connection completely safe.

**DO**

> Think of DNS as the Internet's phone book: it turns a name such as `example.com` into an address a device can contact.

**DON'T**

> DNS is basically magic that finds websites for you.

## Keep the Reader Moving

Use a repeatable rhythm:

1. Name the situation or goal.
2. Explain why the next action matters.
3. Give the action in concrete language.
4. State what the reader should see or test.
5. Explain what to do if the result differs.

Use transitions that show where the reader is in the journey: `At this point`, `For this reason`, `Once that works`, `Before moving on`, `In my case`, `However`, and `Before celebrating`.

**DO**

> The service is running, but traffic from the rest of the network still stops at the gateway. We now need forwarding and translation so the gateway can pass that traffic through the connection. After applying the rules, test the route from a second device instead of assuming the gateway is working.

**DON'T**

> Enable forwarding. Add NAT. Test it. Continue with the next configuration.

**DO**

> First, check whether the device can reach the Pi. If that works, test an external address. Only then test DNS. Each result tells us which part of the path is failing.

**DON'T**

> Run several random tests until something works.

**DO**

> The installer is asking for an upstream DNS provider. Choose a temporary provider for now; we will replace it after the VPN tunnel is working.

**DON'T**

> Select the DNS provider and proceed through the wizard.

## Vary Sentence Length and Pacing

The guides alternate longer explanatory sentences with short beats. Use a short sentence to land a point, create anticipation, or acknowledge a result. Do not make every sentence short or turn every paragraph into a dramatic performance.

**DO**

> The first connection may take a little longer because the phone is creating its VPN profile. Give it a moment. Once the connected indicator appears, check the public IP address before browsing normally.

**DON'T**

> The connection may take longer. Wait. Check the indicator. Check the IP. Browse.

**DO**

> That result looks alarming, but it does not necessarily mean that the tunnel failed. The checker is seeing a DNS provider that is not operated by the VPN service, so we need to understand what it is measuring.

**DON'T**

> The result is alarming and confusing and important and needs to be fixed immediately.

**DO**

> Pretty useful, isn't it? The small test tells us much more than a green icon alone.

**DON'T**

> Wow!!! Amazing!!! This is absolutely incredible!!!

## Use Rhetorical Questions as Conversation

A question can anticipate the reader's next thought, especially when a term or choice is unfamiliar. Answer it immediately. Use this device occasionally, not at the start of every paragraph.

**DO**

> "Why not leave the address dynamic?" Because another device needs to know where to find the gateway tomorrow, not only today.

**DON'T**

> Why? Why? Why? There are many questions we need to answer before we continue.

**DO**

> "WireGuard? What is that?" It is the software that reads the VPN configuration and creates the encrypted tunnel.

**DON'T**

> You may be wondering about a number of important and interesting questions regarding WireGuard and its many benefits.

**DO**

> What if the check still reports a DNS problem? Then we test whether the browser is bypassing the system resolver before changing the whole network.

**DON'T**

> What if it fails? Don't worry, everything is easy and will work perfectly.

## Be Warm, but Keep the Technical Center

Small reactions such as `Okay`, `Great`, `Pretty exciting`, or `Before celebrating` give the article a human pulse. Use them around meaningful progress. Avoid hype, sales language, and forced slang.

**DO**

> Great, the gateway can now reach the Internet through the connection. We still need to test another device, because the routed path is a separate part of the setup.

**DON'T**

> Great!!! Your network is now an unstoppable privacy fortress that no one can ever penetrate!

**DO**

> This is a useful result, but it is not the end of the test.

**DON'T**

> This game-changing breakthrough proves that every privacy problem is solved.

**DO**

> If you are not used to the terminal, this command may look intimidating. It only asks the system to display the current interface details.

**DON'T**

> Even beginners can effortlessly master this advanced enterprise-grade workflow.

## Be Precise About Privacy and Security

The reference style earns trust by stating what a tool does and does not do. Keep that habit. Do not promise anonymity, perfect security, total protection, or universal compatibility.

**DO**

> A VPN can hide your public IP address from the websites you visit and encrypt the path to the VPN server. It does not stop tracking through accounts, cookies, browser fingerprints, or information you submit yourself.

**DON'T**

> A VPN makes you completely anonymous and protects everything you do online.

**DO**

> This configuration reduces exposure for devices using the gateway. It does not protect a device that uses another resolver or bypasses the gateway.

**DON'T**

> Once this is installed, every device is fully protected no matter how it connects.

**DO**

> The setting is usually available, but its name can vary by operating system and app version.

**DON'T**

> Every version has exactly the same setting in exactly the same place.

## Calibrate Certainty

Use words such as `usually`, `may`, `often`, `in my case`, `depending on`, and `as a starting point` when the result depends on hardware, software version, network conditions, or user configuration. Qualification is not weakness; it tells the reader what to verify.

**DO**

> A nearby server will usually be a sensible starting point, although distance, load, and network routing all affect the result.

**DON'T**

> The nearest server is always the fastest server.

**DO**

> The command should return a response similar to the example below. Your interface name, address, and server may be different.

**DON'T**

> You will see exactly the output shown here.

**DO**

> If the option is available in your app version, enable automatic connection when that behavior suits your routine.

**DON'T**

> Enable this option because everyone needs it.

## Troubleshoot by Isolating Variables

Troubleshooting in this style is calm and staged. Start with the simplest dependency, change one variable at a time, and use each result to narrow the cause. Explain why the order matters.

**DO**

> First confirm that ordinary Wi-Fi works without the VPN. Then try a nearby server. If the app connects but one website still fails, check DNS or local-network settings instead of changing the protocol, server, and battery settings at the same time.

**DON'T**

> If it does not work, restart everything, change all the settings, and try again.

**DO**

> If the first connectivity check fails, check the device's gateway. If the gateway responds but the external address does not, inspect routing. If the external address works but a domain does not resolve, investigate name resolution.

**DON'T**

> Check the network, firewall, DNS, and router until the issue goes away.

**DO**

> Do not disable the protection merely to make the test green. Find out whether the failure comes from a captive portal, an unavailable server, or a local rule first.

**DON'T**

> Turn off the safety feature whenever it gets in the way.

## Handle Warnings Without Panic

Place warnings where the reader can act on them. Explain the consequence and the recovery path. Avoid theatrical danger language.

**DO**

> If you are connected over SSH, the address change may drop your session. Reconnect using the new address before continuing.

**DON'T**

> Warning!!! This command is extremely dangerous and could destroy everything!!!

**DO**

> Keep the access token private. Anyone who has it may be able to use the remaining account time, so do not include it in screenshots or support requests.

**DON'T**

> Share your account number freely because it is only a harmless identifier.

**DO**

> Save the current setting before changing it, and make one change at a time so you can restore the previous behavior if the result is worse.

**DON'T**

> Change the configuration until the problem disappears; you can work out what happened later.

## Use Emphasis With Restraint

Emphasize a product name, command, setting, protocol, or critical distinction when it helps scanning. Do not make every technical noun bold or repeat the same keyword in every sentence.

**DO**

> Set the **gateway device** as the **default route**, then verify that name resolution still points to the intended **resolver**.

**DON'T**

> Set the **gateway device** as the **DEFAULT ROUTE** and make sure it uses the intended **NAME RESOLVER** for the **NETWORK**.

**DO**

> The app being open is not the same as the VPN being connected.

**DON'T**

> The app is open, which means the app is open, and the app being open means the VPN is probably open too.

## Build Sections That Feel Like a Guided Journey

Use clear, practical headings. A typical flow is:

1. Introduce the problem and the result the reader can expect.
2. Define the important concept in plain language.
3. List what the reader needs.
4. Move through numbered stages.
5. Verify the result after meaningful changes.
6. Add a troubleshooting section that uses the observed symptoms.
7. State the limits and maintenance advice.
8. Recap the working setup and close warmly.

Each section should answer the question raised by the previous one. Avoid sections that exist only to repeat a keyword.

**DO**

> ## 4. Test the route in stages
>
> We can now check the local gateway, the external address, and DNS separately. If one stage fails, we will know where to look next.

**DON'T**

> ## Everything You Need to Know About the Best Network Solution
>
> This section covers many important aspects and benefits of the topic.

**DO**

> ### If the check still shows a DNS leak
>
> The tunnel may be working even when the browser is using its own DNS-over-HTTPS setting. Test that possibility before rebuilding the VPN configuration.

**DON'T**

> ### More Troubleshooting Information
>
> There can be various issues, so try the solutions below.

## End With a Useful Landing

Strong endings recap the result, remind the reader to maintain the setup, offer a related guide when it truly helps, and finish with a friendly sign-off. Keep the close specific rather than motivational.

**DO**

> Your device is now using the configured connection, and you have verified it instead of trusting an indicator alone. Keep the software updated, and repeat the check after a major network or service change. If you later want to extend the setup to more devices, the broader network guide is the natural next step.

**DON'T**

> In conclusion, this amazing solution is the best choice for everyone. Start your journey today and unlock the future!

**DO**

> So, that is the complete setup. The important part is not only making it work once, but knowing how to test it when a network, server, or app version changes.

**DON'T**

> That's it. Everything is perfect forever.

## House Moves to Reuse Carefully

These are useful patterns for this voice. Treat them as occasional tools, not mandatory catchphrases:

- `Okay, now let's ...` to move into the next action.
- `Wait, ...?` to anticipate an unfamiliar term or surprising choice.
- `In my case, ...` to separate a local example from a universal rule.
- `As you can see, ...` to interpret a screenshot or command result.
- `Before celebrating, ...` to introduce a final verification.
- `If you are not too technical, ...` to translate a command or concept without talking down to the reader.
- `For this reason, ...` to connect a problem to the next action.
- `So, that's it!` as a warm ending only when the article has actually shown the result.

Avoid copying the same transition in every section. The point is an attentive companion voice, not a template that announces itself.

## Final Style Checklist

Before delivering prose, ask:

- Does the opening begin with a real reader concern or concrete situation?
- Does the article sound like a person speaking to one reader?
- Does `we` guide the journey, `you` clarify actions, and `I` mark genuine preference?
- Is every unfamiliar technical term explained before it is used as shorthand?
- Does each major action have a reason and a verification step?
- Do long explanations have short sentences or questions to vary the pace?
- Are asides warm and occasional rather than noisy?
- Are privacy, security, compatibility, and performance claims properly bounded?
- Does troubleshooting change one variable at a time and use symptoms as evidence?
- Are the examples concrete without inventing personal testing or certainty?
- Does the conclusion recap, maintain trust, and end naturally?
- Have generic AI phrases, corporate filler, keyword repetition, and exaggerated promises been removed?

Write with patience, specificity, and a little personality. The reader should finish feeling that the system is understandable and that they know what to check next.