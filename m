Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5BCF221EA0C8
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 11:29:31 -0800 (PST)
Received: by mail-oi0-x22c.google.com with SMTP id o64so5701194oia.9
 for <linux-nvdimm@lists.01.org>; Thu, 07 Dec 2017 11:34:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b025ae2f-0196-8d00-6b3b-aad7c4e23d54@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4iHPTEp9d4PwRF0c=THgJBRFw9NFa-AWJwTdbb78AKjBw@mail.gmail.com>
 <20171120190708.C229.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4jK1=UUgaCPVcf=bdd=RvW6g0+RZQF7BMgw4cP1Owy1oQ@mail.gmail.com>
 <4cfea9d4-50a2-df1c-3064-dbbc61e86708@jp.fujitsu.com>
 <b025ae2f-0196-8d00-6b3b-aad7c4e23d54@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Dec 2017 11:34:03 -0800
Message-ID: <CAPcyv4iG2bGi3bhkPss_OwWewDD=JZ+b6mOiUj6=Enj7_s43LA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 7, 2017 at 1:58 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
[..]
>> Ok, I will make a sample hook up to Fluentd.
>>
>>
> I tried to hook up the current json format output to Fluentd,
> Fluentd parsed each line in the output as a new event.
> The current json format output cannot be consumed by Fluentd without
> any plugins. This is undesired.
> So I changed the multiline json format output to one-line like the following
> sample, then Fluentd parsed it well.
>
> {"datetime":"2017/11/28 11:00:12","pid":7013,"dev":"nmem1","health":{"health_state":"non-critical","temperature_celsius":23,"spares_percentage":75","life_used_percentage":5,"shutdown_state":"clean"}}
>
> I think one-line output will get consumed more easily by other data collect
> services besides Fluentd. All the output items should be placed in json block,
> such as datetime, eventid.
>
> So I would like to change current multi-line json format output to one line
> and move all items into json block.
>

This is just a small matter of using the JSON_C_TO_STRING_PLAIN flag
instead of JSON_C_TO_STRING_PRETTY when emitting json
(json_object_to_json_string_ext()) for Fluentd or another service to
consume.

Also, when creating a json record for Fluentd I think the standard
record that ndctl list reports should be wrapped as a sub-object i.e:

{
  "dev":"nmem3",
  "id":"cdab-0a-07e0-feffffff",
  "handle":1,
  "phys_id":1,
  "health":{
    "health_state":"non-critical",
    "temperature_celsius":23,
    "spares_percentage":75,
    "alarm_temperature":true,
    "alarm_spares":true,
    "temperature_threshold":80.125,
    "spares_threshold":128,
    "life_used_percentage":5,
    "shutdown_state":"clean"
  }
}

...becomes:

{
  "timestamp":"YYYY/MM/DD HH:mm:ss",
  "pid":1234,
  {
    "dev":"nmem3",
    "id":"cdab-0a-07e0-feffffff",
    "handle":1,
    "phys_id":1,
    "health":{
      "health_state":"non-critical",
      "temperature_celsius":23,
      "spares_percentage":75,
      "alarm_temperature":true,
      "alarm_spares":true,
      "temperature_threshold":80.125,
      "spares_threshold":128,
      "life_used_percentage":5,
      "shutdown_state":"clean"
    }
  }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
