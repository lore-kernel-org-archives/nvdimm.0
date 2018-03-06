Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4ED0420955F3D
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 11:15:05 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id 108so19405044otv.3
 for <linux-nvdimm@lists.01.org>; Tue, 06 Mar 2018 11:21:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180305235613.9688-1-vishal.l.verma@intel.com>
References: <20180305235613.9688-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Mar 2018 11:21:17 -0800
Message-ID: <CAPcyv4gC=5C3+JYXjALoGJi5e6_H6NAXFapigX4pO4X-WxX9GA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, {btt,
 blk}: do integrity setup before add_disk()
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 5, 2018 at 3:56 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Prior to 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
> we needed to temporarily add a zero-capacity disk before registering for
> blk-integrity. But adding a zero-capacity disk caused the partition
> table scanning to bail early, and this resulted in partitions not coming
> up after a probe of the BTT or blk namespaces.
>
> We can now register for integrity before the disk has been added, and
> this fixes the rescan problems.
>
> Fixes: 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
> Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
