Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0CFA203B8CF0
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 23:22:53 -0700 (PDT)
Date: Tue, 22 May 2018 08:28:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v10] mm: introduce MEMORY_DEVICE_FS_DAX and
 CONFIG_DEV_PAGEMAP_OPS
Message-ID: <20180522062806.GD7816@lst.de>
References: <152658753673.26786.16458605771414761966.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180518094616.GA25838@lst.de>
 <CAPcyv4iO1yss0sfBzHVDy3qja_wc+JT2Zi1zwtApDckTeuG2wQ@mail.gmail.com>
 <20180521090410.7ygosxzjfhceqrq4@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180521090410.7ygosxzjfhceqrq4@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>, kbuild test robot <lkp@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Christoph Hellwig <hch@lst.de>, Thomas Meyer <thomas@m3y3r.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 21, 2018 at 11:04:10AM +0200, Jan Kara wrote:
> We definitely do have customers using "execute in place" on s390x from
> dcssblk. I've got about two bug reports for it when customers were updating
> from old kernels using original XIP to kernels using DAX. So we need to
> keep that working.

That is all good an fine, but I think time has come where s390 needs
to migrate to provide the pmem API so that we can get rid of these
special cases.  Especially given that the old XIP/legacy DAX has all
kinds of known bugs at this point in time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
