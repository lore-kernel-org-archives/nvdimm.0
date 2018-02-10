Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E41B5223DB789
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 20:00:50 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id 24so7575192oij.3
 for <linux-nvdimm@lists.01.org>; Fri, 09 Feb 2018 20:06:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Feb 2018 20:06:35 -0800
Message-ID: <CAPcyv4hrrf2XyHL4gSVoh59n8oQad_eMshc0e9NfuVfVCUwtaw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] ndctl: monitor: monitor the smart events of
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 9, 2018 at 12:02 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This is a patch set of ndctl monitor, a tiny daemon to monitor the smart
> events of nvdimm dimms. When a smart event fires, monitor will output
> the notification which including dimm health status to syslog or a
> special file according to users' configuration. The output notification
> follows json format and can be consumed by log collectors like Fluentd.
>
> Currently, I implemeted the following four commands to control monitor daemon.
> $ndctl create-monitor
> $ndctl list-monitor
> $ndctl show-monitor
> $ndclt destroy-monitor
>
> I will appreciate if you could give some comments.

Nice to see this new update.

I have a high level comment on the proposed command structure, as far
as I can see the only new command we need is:

   ndctl monitor

...that launches a monitor. We can have options to control whether
that monitor is a one-shot check of events sources, or a daemon that
forks into the background, but the 'create', 'list', 'show', and
'destroy' are the responsibility of systemd or System V services. For
example:

    create: systemctl start ndctl-monitor
    show: systemctl status ndctl-monitor
    destroy: systemctl stop ndctl-monitor
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
