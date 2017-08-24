Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6025D21D2E63B
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 07:45:44 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id 187so7337218oig.1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 07:48:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824134500.GA25037@lst.de>
References: <20170824134500.GA25037@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 07:48:18 -0700
Message-ID: <CAPcyv4iuSJ5NFt4dLKWm9gemgKm3WggpFWoMFmbCq8wAKVN6+A@mail.gmail.com>
Subject: Re: fs_dax_get_by_host in the hot path
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 6:45 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Dan,
>
> I just noticed that we now do a fs_dax_get_by_host in every
> iomap_begin call for DAX.  This function iterates a list,
> does a string compared and igrab.  I really think we need
> to cache this in the superblock (possible even the fs
> superblock) similar to what we do for the block device.

Sure, I'll get that fixed up. I believe I arrived at this scheme as a
side-effect / misunderstanding of this comment:

https://groups.google.com/d/msg/linux.kernel/9ho8SFe6RSw/6zTgNaNTCgAJ
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
