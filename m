Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0E192095BB68
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 16:40:06 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id n18so33468400oig.2
 for <linux-nvdimm@lists.01.org>; Tue, 05 Sep 2017 16:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1131391F-F14B-48F8-9416-037FF0DF2128@fb.com>
References: <0DEDF3B159719A448A49EF0E7B11E3222756C8BF@g01jpexmbkw01>
 <CAPcyv4gO+L5RTi2+RL+YzS4uQF3bdSAOuxDD1to3_g8Quj4G7w@mail.gmail.com>
 <CAPcyv4jw9vsoGY1Mto6+yJChvgeT4Fkkz=4dE1kW34LDQR_65A@mail.gmail.com>
 <1131391F-F14B-48F8-9416-037FF0DF2128@fb.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Sep 2017 16:42:55 -0700
Message-ID: <CAPcyv4jLP9=3Sgd-cgh8+1YA+gfg8K1oZ4mAwmoEcprfrbAEMw@mail.gmail.com>
Subject: Re: [RFC patch 0/4]ndctl: nvdimmd: notify/monitor the feathers of
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
To: Song Liu <songliubraving@fb.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 5, 2017 at 4:10 PM, Song Liu <songliubraving@fb.com> wrote:

> Hi Dan,
>
> Thanks for adding me to the thread.
>
> Hi QI,
>
> I am not familiar with the NVDIMM code, so my experiences may not apply
> well
> to your case.
>
> We have done multiple designs to capture SCSI sense code in a log. The
> first
> thing we learnt is do NOT use kernel debug messages (dmesg). The dmesg can
> easily get too noisy (for SCSI), which sometimes slows down your data path.
> Our first version is based on dmesg, which was not successfully.
>
> We have tried a few other options: ftrace, uevent, and BPF based solution.
> The benefit of these solutions (over dmesg) is that they send structured
> data
> instead of plain text. All these solutions worked for me as prototype. I am
> currently pushing a BPF based solution to production.
>
> Another important lesson is to enable filtering and rate limits, and you
> need
> it to be flexible.
>
>
> I hope these are helpful for your use cases. Please feel free to shoot me
> email for any questions.
>
>
So, do you think it would be enough if this daemon just captured all the
raw nvdimm events from the kernel and turned them into json records? I'm
just wondering what to do with the event data to make it easier to consume
by upper layer software, turn it into a Thrift endpoint?

In other words I want this to be a general building block that can be
integrated into production monitoring environments with various monitoring
infrastructures vs hard coding / prescribing a specific interface.

In any event, thanks for sharing your experience.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
