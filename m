Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x229.google.com (mail-yw0-x229.google.com
 [IPv6:2607:f8b0:4002:c05::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 259CF21D0918B
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 12:32:28 -0700 (PDT)
Received: by mail-yw0-x229.google.com with SMTP id l82so35860799ywc.2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 12:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170726175104.GA21677@infradead.org>
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
 <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
 <20170726175104.GA21677@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 12:34:29 -0700
Message-ID: <CAPcyv4h_8m+fRBUZB=Qz5A=TG4QNSd4yaDMWMrJbk=BtwHeKRg@mail.gmail.com>
Subject: Re: Daemon of NVDIMM event notification/monitoring(Re:
 Standardization of ACPI NVDIMM DSMs)
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 10:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Btw, why do you want to pull it into the kernel tree?  All the tools
> in the kernel tree are a massive pain in the ass to use because it
> requires a full kernel tree on every test box and VM.  Small little
> repos that don't have giant churn are a lot easier to deal with.  And
> also to test for compatibility issues.
>
> They also are painful for distributions as they now have to come up
> with a wrapper to pick the right tool for the right kernel version,
> which have a tendency to fail if you build your own kernels.

I'm mainly motivated to get the tests closer to the test
infrastructure, and raise the profile to get more contributions from
other vendors and archs.

You're right, the requirement to have a full kernel tree to play with
the source is a pain. I think that's why we now have the "make
perf-tar-src-pkg" target so you can pass that around to test boxes and
VMs. As for compatibility there's no requirement to match ndctl to
kernel version, it's all auto-detected with fall backs for older
kernels.

However, the pain of moving away from autotools may delay this indefinitely.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
