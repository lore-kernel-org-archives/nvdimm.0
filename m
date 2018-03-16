Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E3E7220C2A7F
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 17:57:26 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id b8so7322446oib.11
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 18:03:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58684e81-ac3a-718e-a717-0a1b54766100@jp.fujitsu.com>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <58684e81-ac3a-718e-a717-0a1b54766100@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 18:03:49 -0700
Message-ID: <CAPcyv4jRxaVu6XXcRDatr8VHJAdR-nn7DVb9Z3oUs_MmK9sBAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 3:41 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>>>
>>> In this implemention, when a ndctl monitor starts with [--daemon] option, all
>>> the arguments will be saved into a temp file named as daemon-name and placed
>>> under /etc/sysconfig/ndctl/ directory. The temp file would be used as an
>>> EnvironmentFile by systemd, and it would be deleted automatically when the
>>> systemd service is stopped.
>>
>> The monitors started by hand should be kept separate from the monitors
>> started by systemd. The default monitor started by systemd should get
>> its configuration from /etc/ndctl.conf, and we should otherwise have a
>> --conf-file option to the monitor to override the default
>> configuration. Any other monitors started outside of the systemd
>> should remain independent.
>
> Thank you very much for your comments. I still have something unclear about
> how to manage ndctl monitor daemon. Let's clarify the specification of monitor daemon.
>
> I have the following questions.
>  a) About command line interface
>     1) I would like to confirm when a monitor daemon is launched  by using
>        command line interface with [--daemon] option (like # ndctl monitor
>        --dimm nmem1 --daemon), then how to manage it? (i.e. stop, check status)

I don't want to invent new policy here, how do other daemons behave
with respect to this, can you investigate? Use mdadm or dnsmasq as an
example.

>     2) When multiple daemons be running at same time, how can we recognize
>        each of them?

Process id.

>
>  b) About using systemctl command
>     3) Should we need to limit the maximum number of running daemons to be one?
>        If yes, I am thinking the option should support multiple values, then
>        users can modify the default configuration by using [--conf-file] option.
>        # ndctl monitor --dimm nmem1,nmem2 --conf-file
>
>     4) If multiple daemons can be running at the same time, multiple configuration
>        files named <daemon-name> are needed. Do you agree that let users create the
>        configuration file manually when they want to launch a monitor daemon?

Yes, we should always support a local configuration file in addition
to the default configuration.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
