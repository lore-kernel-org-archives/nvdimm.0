Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F58E21F2E10A
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 02:32:11 -0700 (PDT)
Date: Mon, 9 Apr 2018 02:32:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
Message-ID: <20180409093211.GA30549@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
 <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
 <20180406070310.GA16984@infradead.org>
 <CAPcyv4g7kzRQqR63BFQXww5axjaZzdBb+pAGzC6TvfpxoTq+Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g7kzRQqR63BFQXww5axjaZzdBb+pAGzC6TvfpxoTq+Sg@mail.gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 06, 2018 at 03:41:39PM -0700, Dan Williams wrote:
> Yes, but the trust interface definition is what is missing, especially
> when we consider memmap=ss!nn and qemu-kvm. For example do we turn off
> DAX and/or MAP_SYNC on all platforms that don't provide a positive "I
> have ADR" indication (ACPI 6.2 Section 5.2.25.9 NFIT Platform
> Capabilities Structure)?

Sounds like a default.

> Require opt-in when the user has trust in the
> hardware config that the kernel can't verify?

And that sounds like a good config nob ontop of that default.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
