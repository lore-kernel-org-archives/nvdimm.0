Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5111A21CF1CEB
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 17:48:50 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 880BDAC00A6
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 10:54:35 +0900 (JST)
Subject: Re: [RFC PATCH v3 0/5] ndctl: monitor: monitor the smart events of
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4hrrf2XyHL4gSVoh59n8oQad_eMshc0e9NfuVfVCUwtaw@mail.gmail.com>
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Message-ID: <13e04914-25fd-8b64-86e0-14d9c2263e91@jp.fujitsu.com>
Date: Tue, 13 Feb 2018 10:54:26 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hrrf2XyHL4gSVoh59n8oQad_eMshc0e9NfuVfVCUwtaw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 2018/02/10 13:06, Dan Williams wrote:

> On Fri, Feb 9, 2018 at 12:02 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> This is a patch set of ndctl monitor, a tiny daemon to monitor the smart
>> events of nvdimm dimms. When a smart event fires, monitor will output
>> the notification which including dimm health status to syslog or a
>> special file according to users' configuration. The output notification
>> follows json format and can be consumed by log collectors like Fluentd.
>>
>> Currently, I implemeted the following four commands to control monitor daemon.
>> $ndctl create-monitor
>> $ndctl list-monitor
>> $ndctl show-monitor
>> $ndclt destroy-monitor
>>
>> I will appreciate if you could give some comments.
> Nice to see this new update.
>
> I have a high level comment on the proposed command structure, as far
> as I can see the only new command we need is:
>
>     ndctl monitor
>
> ...that launches a monitor. We can have options to control whether
> that monitor is a one-shot check of events sources, or a daemon that
> forks into the background, but the 'create', 'list', 'show', and
> 'destroy' are the responsibility of systemd or System V services. For
> example:
>
>      create: systemctl start ndctl-monitor
>      show: systemctl status ndctl-monitor
>      destroy: systemctl stop ndctl-monitor
>
>
Thank you for your comments, I will use systemd in next version.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
