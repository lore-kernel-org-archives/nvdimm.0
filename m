Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2411202E5CDA
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 14:37:26 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: what happened to byte-addressable read()/write() to character
 device DAX?
References: <efdf3c01-b91b-4b69-33a8-90cbccfe803d@oracle.com>
Date: Thu, 19 Oct 2017 17:41:03 -0400
In-Reply-To: <efdf3c01-b91b-4b69-33a8-90cbccfe803d@oracle.com> (jane chu's
 message of "Thu, 19 Oct 2017 10:04:52 -0700")
Message-ID: <x494lquhl3k.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: jane.chu@oracle.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

jane.chu@oracle.com writes:

> Hi, Dan,
>
> Referring to
>
> https://patchwork.kernel.org/project/linux-nvdimm/list/?page=6
>
> [RFC,2/2] mm, fs: daxfile, an interface for byte-addressable updates
> to pmem
>
> I'm unable to find the patch in Linux upstream kernel, and am wondering if
> there has been a change of plan for providing support to byte granularity
> read() and write() to character device /dev/dax.
>
> I've also just started following the email threads, so I might have
> missed some critical discussions.  Would you mind to elaborate what's
> happening to the proposed feature?

Device dax only supports mmap for data path access.  There are no plans
to support read(2) or write(2).

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
