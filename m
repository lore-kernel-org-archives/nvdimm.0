Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A82521E0B9F2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 14:47:52 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] libnvdimm: re-enable deep flush for pmem devices
References: <151847194459.58291.11339638808076622981.stgit@djiang5-desk3.ch.intel.com>
Date: Mon, 12 Feb 2018 17:53:40 -0500
In-Reply-To: <151847194459.58291.11339638808076622981.stgit@djiang5-desk3.ch.intel.com>
 (Dave Jiang's message of "Mon, 12 Feb 2018 14:46:13 -0700")
Message-ID: <x49inb1n7kb.fsf@segfault.boston.devel.redhat.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: ross.zwisler@intel.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> writes:

> Re-enable deep flush so that users always have a way to be sure that a write
> does make it all the way out to the NVDIMM. The PMEM driver writes always
> make it "all the way to the NVDIMM", and it relies on the ADR mechanism to
> flush the write buffers on power failure. Deep flush is there to explicitly
> flush those write buffers to protect against (rare) ADR failure.
> This change prevents a regression in deep flush behavior so that applications
> can continue to depend on fsync() as a mechanism to trigger deep flush in the
> filesystem-dax case.

That's still very confusing text.  Specifically, the part where you say
that pmem driver writes always make it to the DIMM.  I think the
changelog could start with "Deep flush is there to explicitly flush
write buffers...."  Anyway, the fix looks right to me.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
