Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5720A222A54FF
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:12:52 -0800 (PST)
Date: Thu, 4 Jan 2018 09:17:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 00/18] dax: fix dma vs truncate/hole-punch
Message-ID: <20180104081755.GD2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andreas Dilger <adilger.kernel@dilger.ca>, hch@lst.de, Matthew Wilcox <mawilcox@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

> So far this solution only targets xfs since it already implements
> xfs_break_layouts in all the locations that would need this
> synchronization. It applies on top of the vmem_altmap / dev_pagemap
> reworks from Christoph.

Those got a rebase since your posting of this series, btw.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
