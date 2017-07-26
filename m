Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 447BB21D091AB
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:43:53 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id i6so58410000ywb.1
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
 <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 10:45:55 -0700
Message-ID: <CAPcyv4gwPA=bOC-3hyp6rGYgwqauAEgd7JY2uHdhnrbs4vW3rw@mail.gmail.com>
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 24, 2017 at 9:11 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sun, Jul 23, 2017 at 10:50 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
[..]
>> d) make a new tiny daemon in ndctl tree
>>    This may be simpler way.
>>    It can use ndctl_dimm_get_health_eventfd() and poll()/select().
>>
>>    But, ndctl may be included in kernel source,
>>    and I don't know whether kernel includes other daemon tools or not.
>
> The kernel does include a few daemons in the tools/ directory, so I
> don't see this being a problem. Now, that said, Linus still has the
> prerogative to not pull ndctl into the kernel for 4.14, but at this
> point I feel more likely than not that the next version of ndctl will
> be v4.14-rc1 instead of v58.

An update here... upstream would like to see ndctl move away from
autotools before it is integrated into the kernel tree, so ndctl v58
will be the next release from github. The 4.15 kernel is our next
potential intercept.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
