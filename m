Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CDF721D091A7
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:49:03 -0700 (PDT)
Date: Wed, 26 Jul 2017 10:51:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Daemon of NVDIMM event notification/monitoring(Re:
 Standardization of ACPI NVDIMM DSMs)
Message-ID: <20170726175104.GA21677@infradead.org>
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
 <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Btw, why do you want to pull it into the kernel tree?  All the tools
in the kernel tree are a massive pain in the ass to use because it
requires a full kernel tree on every test box and VM.  Small little
repos that don't have giant churn are a lot easier to deal with.  And
also to test for compatibility issues.

They also are painful for distributions as they now have to come up
with a wrapper to pick the right tool for the right kernel version,
which have a tendency to fail if you build your own kernels.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
