Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56F3921E0B9F5
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 13:31:08 -0800 (PST)
Received: by mail-ot0-x230.google.com with SMTP id r23so15356713ote.8
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 13:36:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151847092019.55141.3473410868525983789.stgit@djiang5-desk3.ch.intel.com>
References: <151847092019.55141.3473410868525983789.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Feb 2018 13:36:56 -0800
Message-ID: <CAPcyv4hJn6p1R0C3obe67OU1rWGnvSSdNL7gHqVc4n6mS7OgAw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: re-enable deep flush for pmem devices
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
Cc: "Zwisler, Ross" <ross.zwisler@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 12, 2018 at 1:28 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Re-enable deep flush so that users always have a way to be sure that a write
> does make it all the way out to the NVDIMM.

I think this changelog needs to be a bit more clear/precise. The PMEM
driver writes always make it "all the way to the NVDIMM", and it
relies on the ADR mechanism them through write buffers on power
failure. Deep flush is there to explicitly flush those write buffers
to protect against (rare) ADR failure. This change prevents a
regression in deep flush behavior so that applications can continue to
depend on fsync() as a mechanism to trigger deep flush in the
filesystem-dax case.

Can you incorporate that feedback and also copy lkml on the resend?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
