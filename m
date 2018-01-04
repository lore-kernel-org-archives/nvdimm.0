Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A14B222D1555
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:24:37 -0800 (PST)
Date: Thu, 4 Jan 2018 09:29:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 14/18] ext2: use DEFINE_FSDAX_AOPS
Message-ID: <20180104082940.GJ2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407703518.38751.15720592028869946071.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407703518.38751.15720592028869946071.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Same comment as for XFS applies here as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
