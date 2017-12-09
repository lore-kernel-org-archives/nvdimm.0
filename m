Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 851812035624A
 for <linux-nvdimm@lists.01.org>; Sat,  9 Dec 2017 15:49:39 -0800 (PST)
Received: by mail-ot0-x236.google.com with SMTP id s4so12011460ote.4
 for <linux-nvdimm@lists.01.org>; Sat, 09 Dec 2017 15:54:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ca3a1730-5ca8-3979-3086-6e47edea53e0@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <20171114074704.3446-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4j0jhb28ihCwWyC-pjSFSsaW02Lf_Gt_7XH3MPWMMn+qg@mail.gmail.com>
 <445e8b8d-3584-b0c5-3a0c-cab269e42684@jp.fujitsu.com>
 <CAPcyv4hW5vTDj3w1xJ9w6DzQcYM0tMyExMthMTbZWGhPhG=3mw@mail.gmail.com>
 <ca3a1730-5ca8-3979-3086-6e47edea53e0@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 9 Dec 2017 15:54:13 -0800
Message-ID: <CAPcyv4jDQh9A5gLyY_XXELfkrcj=WwNdbBHbJBY2KKUc+7+fTw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/7] ndctl: nvdimmd: add nvdimmd necessary util
 functions
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

On Thu, Dec 7, 2017 at 1:55 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>
>>>>> +       rename(file, buf);
>>>>> +}
>>>>
>>>> Why does the monitor need to rotate logs? This should be the
>>>> responsibility of whatever is consuming  the nvdimmd events.
>>>
>>> When I wrote it, I thought that users can rotate nvdimmd logs without
>>> using
>>> other tools.
>>> If you think it is not necessary, I will remove it in next version.
>>>
>> In general we should let other system components handle the mechanics
>> they are responsible to handle. In this case as long as nvdimmd
>> reports the log message to the systemd-journal or the platform's
>> syslog facility then it has done its job and the log machinery is
>> responsible for rotation.
>>
>> I've also been giving more thought about the command line interface
>> for the monitor. I think it should reuse the "ndctl list"
>> infrastructure for selecting and filtering devices so the user can
>> launch monitors like this:
>>
>>          ndctl monitor --dimms --namespace=namespace0.0
>> --action=page_admin.sh
>>          ndctl monitor -BDRN --action=log
>>
>> Where those commands would  run the 'page admin' script if any DIMM
>> event happens on any DIMM associated with namespace0.0, and log
>> everything else" that happens on any other device. We likely also need
>> "--event=" to control the events to filter, and a --list-events option
>> to enumerate all the possible events.
>>
>>
> My original plan was user launches the nvdimm monitor services with
> systemctl command
> like: $systemctl start nvdimmd, then nvdimmd reads a config file
> to select and filter devices or any other settings.
>
> In my first impression, your idea, which is by command line options,
> seems to be attractive. But I'm not sure yet.
>
> So, I have some questions.
>
> Q1) Which is better interface config file or command option?
>
>     For example, please consider a use-case which user execute
>     plural nvdimm daemons to monitor plural areas.
>
>    - config file
>      To make plural daemons, user need to prepare different name of
>      config files.
>      But, user can manage each daemon with the name of files.
>
>    - ndctl
>      It is easy to make environment plural nvdimm daemons.
>      However, I could not find the way for users to manage them.
>      How to specify each daemon to stop/restart them?

Every option that can be specified via a configuration file should
also be enabled via a command line operation, see dnsmasq as an
example.

The systemd service file can launch a single instance to use a default
configuration file, but that's just a default that the user is free to
ignore and they can always launch monitor instances by hand for
testing or custom monitoring purposes.

> Q2) What filter option is necessary?
>    a) filter by dimm
>    b) filter by bus
>    c) filter by region
>    d) filter by namespace
>    e) filter by device name
>    f) filter by event
>    g) all (default)
>
>   a) is already implemented because it is easy.
>      (However, to be honest, I don't have any concrete use-case.
>       Do you have any idea?)
>   b) is same with a). I don't know any use-case about bus-filter.
>      (any use-case?)
>   c), d) or e) will be probably necessary.
>     Probably, I think it is useful to notify each applications
>     which uses each regions/namespace.
>     However, I feel I need more time to investigate how to implement it yet.

You don't need to implement it. All of this filtering is already
present in the 'ndctl list' command. We just need to refactor the code
that walks and filters the device tree to be re-used by the monitor
implementation.

>   f) I don't have idea what kind of event should be filtered.
>         Currently, I can think the followings
>         - spare threshold event
>         - temperature threshold event
>     Would you mind elaborating a bit more?

Every event that we can monitor needs a name and a corresponding event
record format in json. The event list I can think of is:

dimm-spares-remaining
dimm-media-temperature
dimm-controller-temperature
dimm-health-state
dimm-unclean-shutdown
dimm-detected
namespace-media-error
namespace-detected
region-media-error
region-detected
bus-media-error
bus-address-range-scrub-complete
bus-detected

Any others?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
