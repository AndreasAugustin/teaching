# How to build a chat bot with AWS LEX

## Abstract

When you offer customer support, often it is way more flexible for all parties to have a chat bot leading to the right audience. Also it is a well known feature to use speach to chat functionalities like **Alexa, Hello Google or Siri**

## About AWS LEX

*Amazon Lex is an AWS service for building conversational interfaces for applications using voice and text. With Amazon Lex, the same conversational engine that powers Amazon Alexa is now available to any developer, enabling you to build sophisticated, natural language chatbots into your new and existing applications. Amazon Lex provides the deep functionality and flexibility of natural language understanding (NLU) and automatic speech recognition (ASR) so you can build highly engaging user experiences with lifelike, conversational interactions, and create new categories of products.*[^lex-what-is]

So in special **AWS LEX** is the same like **Alexa**. The main difference is that you do not need to own a Amazon Developer Account. An AWS Account is sufficient.

## Tutorial

Within this tutorial we want to setup an easy chat workflow.

As a prerequisite you need to be logged in into an AWS account with sufficient privileges to create IAM roles and to access AWS LEX.

Go to the LEX dashboard
![aws service](../assets/aws/lex/1_lex_aws_services.png)

![lex dashboard](../assets/aws/lex/assets/2_lex_dashboard.png)

### Create a bot

Firstly we want to create a bot

- click `create bot`
![lex create bot](../assets/aws/lex/3_1_lex_create_bot.png)
- choose a meaningful name and let **LEX** create the role
![lex create bot](../assets/aws/lex/3_2_lex_create_bot.png)
- we set COPPA settings to `No` because out of testing purposes we do not have children as customers so
![lex create bot](../assets/aws/lex/3_3_lex_create_bot.png)
- click Next
![lex create bot](../assets/aws/lex/3_4_lex_create_bot.png)
- For the language settings, use Voice interactions
- click `Done`

## Intents Basics

### Create buy intent

After the bot creation you are redirected to the first intent

- rename to `BuyIntent`
![lex buy intent](../assets/aws/lex/4_1_lex_buy_intent.png)
- add samples
  - `buy`
  - `I want to buy things`
![lex buy intent](../assets/aws/lex/4_2_lex_buy_intent.png)
- add initial response `Okay, I like to help you buying things`
![lex buy intent](../assets/aws/lex/4_3_lex_buy_intent.png)
- do not add slots (we will cover this later)
![lex buy intent](../assets/aws/lex/4_4_lex_buy_intent.png)
- save and build the intent: click build
![lex buy intent](../assets/aws/lex/4_5_lex_buy_intent.png)
- wait until the build has finished, now test it: click test
![lex buy intent](../assets/aws/lex/4_6_lex_buy_intent.png)
- we want to inspect the test: click Inspect
![lex buy intent](../assets/aws/lex/4_7_lex_buy_intent.png)
- type in the message bar `let's buy things`
![lex buy intent](../assets/aws/lex/4_8_lex_buy_intent.png)
- We see as a chatbot answer that it hits our BuyIntent. That is also shown within the Inspect window. If you remember, we did not add the sentence `let's buy things` into the sample utterances. Here the power of **AI** kicks in :rocket:
![lex buy intent](../assets/aws/lex/4_9_lex_buy_intent.png)
- When you type a message like `Thanks` you see that you will now hit the FallbackIntent
![lex buy intent](../assets/aws/lex/4_10_lex_buy_intent.png)

### Create sell intent

Intents are a way to manage flows with examples. As mentioned before **AI** will handle chat messages which are close to the samples. Lets create a second intent

- Lets go back to intents list
![lex sell intent](../assets/aws/lex/5_1_lex_sell_intent.png)
- click `Add Intent`
![lex sell intent](../assets/aws/lex/5_2_lex_sell_intent.png)
- add name `SellIntent`
![lex sell intent](../assets/aws/lex/5_3_lex_sell_intent.png)
- add samples
  - `sell`
  - `I want to sell things`
![lex sell intent](../assets/aws/lex/5_4_lex_sell_intent.png)
- add initial response `Okay, lets make some money`
![lex sell intent](../assets/aws/lex/5_5_lex_sell_intent.png)
- leave Slots empty (will be covered later)
![lex sell intent](../assets/aws/lex/5_6_lex_sell_intent.png)
- save, build, test with Inspect
![lex sell intent](../assets/aws/lex/5_7_lex_sell_intent.png)
- add messages
  - `sell`
  - `I want to sell things`
Within the chat bot response and within inspect you see that you hit our `SellIntent`
![lex sell intent](../assets/aws/lex/5_8_lex_sell_intent.png)
- Add message `buy`. You can see that we hit the `BuyIntent`
![lex sell intent](../assets/aws/lex/5_9_lex_sell_intent.png)

## Slots and slot types

As we have seen it is possible to define so called **slots** for the Intents.

*For each intent, you can specify parameters that indicate the information that the intent needs to fulfill the user's request. These parameters, or slots, have a type. A slot type is a list of values that Amazon Lex uses to train the machine learning model to recognize values for a slot. For example, you can define a slot type called "Genres." Each value in the slot type is the name of a genre, "comedy," "adventure," "documentary," etc. You can define a synonym for a slot type value. For example, you can define the synonyms "funny" and "humorous" for the value "comedy."*[^lex-custom-slots]

### Create custom slot type

To be able to use custom slots, you need to create **Slot types** first.

- click in the navigation bar onto `Language: English (US)`
![lex slot types](../assets/aws/lex/6_1_lex_slot_types.png)
- Within the side menu you need to click `Slot types`
![lex slot types](../assets/aws/lex/6_2_lex_slot_types.png)
- click `Add slot types`
![lex slot types](../assets/aws/lex/6_3_lex_slot_types.png)
- Add a name which fits the context
![lex slot types](../assets/aws/lex/6_4_lex_slot_types.png)
- also a description is nice to add to be sure to understand the context some months later :ninja:
![lex slot types](../assets/aws/lex/6_5_lex_slot_types.png)
- add some values
![lex slot types](../assets/aws/lex/6_6_lex_slot_types.png)

### intents add slots

Now you can add custom and prebuilt slot types within your intents

- click on the left navigation `Intents` and then `BuyIntent`
![lex intent slot](../assets/aws/lex/7_1_lex_intent_slots.png)
- scroll to the slot section
![lex intent slot](../assets/aws/lex/7_2_lex_intent_slots.png)
- click `Add slot` name it `context` and choose as slot type the former defined one `DeviceType`
![lex intent slot](../assets/aws/lex/7_3_lex_intent_slots.png)
- add the prompt which should be shown when it is mentioned
![lex intent slot](../assets/aws/lex/7_4_lex_intent_slots.png)
- add a second slot for mail
![lex intent slot](../assets/aws/lex/7_4_lex_intent_slots_mail.png)
- now we can add the slots to our utterances with `{<slot_name>}`
![lex intent slot](../assets/aws/lex/7_5_lex_intent_slots.png)
- adjust the utterances to look like
![lex intent slot](../assets/aws/lex/7_6_lex_intent_slots.png)
- saving the intent is not working because we need to add a confirmation
![lex intent slot](../assets/aws/lex/7_7_lex_intent_slots.png)
- add a confirmation
![lex intent slot](../assets/aws/lex/7_8_lex_intent_slots.png)
- Now lets save, build and test the bot
![lex intent slot](../assets/aws/lex/7_9_lex_intent_slots.png)
as you can see, **LEX** is also validating your input. In this case the mail address

## Immutability (Versions/Aliases)

To make Intents immutable you are able to create versions. This helps a lot if you want to do canary deployments or set up DEV/QA/PROD workflows.

- ![lex alias and version](../assets/aws/lex/8_1_lex_versions_aliases.png)
- ![lex alias and version](../assets/aws/lex/8_2_lex_versions_aliases.png)
- ![lex alias and version](../assets/aws/lex/8_3_lex_versions_aliases.png)
- ![lex alias and version](../assets/aws/lex/8_4_lex_versions_aliases.png)
- ![lex alias and version](../assets/aws/lex/8_5_lex_versions_aliases.png)
- ![lex alias and version](../assets/aws/lex/8_6_lex_versions_aliases.png)

When you want to change the content of the intent, you need to switch to `Draft version`

## Literatur

[cloudformation][lex-cloudformation]
[integrate into a website][lex-integrate-with-website]

[^lex-what-is]: https://docs.aws.amazon.com/lex/latest/dg/what-is.html
[^lex-custom-slots]: https://docs.aws.amazon.com/lex/latest/dg/howitworks-custom-slots.html

[lex-cloudformation]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_Lex.html
[lex-integrate-with-website]: https://docs.aws.amazon.com/lex/latest/dg/ex-web.html
