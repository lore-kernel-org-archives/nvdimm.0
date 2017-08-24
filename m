Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 948342095B9CF
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 08:16:33 -0700 (PDT)
Date: Thu, 24 Aug 2017 17:19:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: fs_dax_get_by_host in the hot path
Message-ID: <20170824151906.GA26646@lst.de>
References: <20170824134500.GA25037@lst.de>
 <CAPcyv4iuSJ5NFt4dLKWm9gemgKm3WggpFWoMFmbCq8wAKVN6+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iuSJ5NFt4dLKWm9gemgKm3WggpFWoMFmbCq8wAKVN6+A@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 07:48:18AM -0700, Dan Williams wrote:
> Sure, I'll get that fixed up. I believe I arrived at this scheme as a
> side-effect / misunderstanding of this comment:
> 
> https://groups.google.com/d/msg/linux.kernel/9ho8SFe6RSw/6zTgNaNTCgAJ

The current scheme is doing the right thing in terms of returning
the dax device from ->iomap_begin.  But it still do so efficiently :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
