Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 120152096DCF9
 for <linux-nvdimm@lists.01.org>; Sun,  1 Jul 2018 23:24:15 -0700 (PDT)
Date: Mon, 02 Jul 2018 14:23:42 +0800
From: Huaisheng Ye <yehs2007@zoho.com>
Message-ID: <16459a9432e.10c419704327.5268154349116077352@zoho.com>
In-Reply-To: <20180701192600.GT30522@ZenIV.linux.org.uk>
References: <20180701061848.7036-1-yehs2007@zoho.com>
 <20180701061848.7036-2-yehs2007@zoho.com>
 <20180701192600.GT30522@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/3] fs/ext2/inode: Fix a type cast error for fsdax
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: yehs2007@zoho.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "\"Al Viro\"" <viro@ZenIV.linux.org.uk>
Cc: linux-nvdimm@lists.01.org, chengnt@lenovo.com, linux-kernel@vger.kernel.org, willy@infradead.org, jack@suse.com, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

 ---- On Mon, 02 Jul 2018 03:26:00 +0800 Al Viro <viro@ZenIV.linux.org.uk> wrote ---- 
 > On Sun, Jul 01, 2018 at 02:18:47PM +0800, Huaisheng Ye wrote: 
 > > From: Huaisheng Ye <yehs1@lenovo.com> 
 > >  
 > > The type of offset within struct iomap is loff_t, which represents 
 > > file offset of mapping. 
 > >  
 > > In ext2_iomap_begin, iomap->offset shall be given a type cast as 
 > > loff_t instead of u64. 
 >  
 > Why is it an error?  loff_t is uniformly typedefed to long long. 
 > In which case the second variant is different from the first one 
 > *and* does not step into nasal demon territory?

Sorry for my inaccuracy.
The type of iomap->offset is loff_t, is it better to cast first_block
to loff_t, then do the left shift operation?
 
 >  
 > > -    iomap->offset = (u64)first_block << blkbits; 
 > > +    iomap->offset = (loff_t)first_block << blkbits; 
 > 

---
Cheers,
Huaisheng

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
