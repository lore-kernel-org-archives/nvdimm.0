Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [103.22.144.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FE56202E5E45
 for <linux-nvdimm@lists.01.org>; Thu,  2 Nov 2017 19:28:55 -0700 (PDT)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 02/15] mm, dax: introduce pfn_t_special()
In-Reply-To: <150949210553.24061.5992572975056748512.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949210553.24061.5992572975056748512.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 03 Nov 2017 13:32:44 +1100
Message-ID: <87ines6qib.fsf@concordia.ellerman.id.au>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Arnd Bergmann <arnd@arndb.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> In support of removing the VM_MIXEDMAP indication from DAX VMAs,
> introduce pfn_t_special() for drivers to indicate that _PAGE_SPECIAL
> should be used for DAX ptes. This also helps identify drivers like
> dccssblk that only want to use DAX in a read-only fashion without
> get_user_pages() support.
>
> Ideally we could delete axonram and dcssblk DAX support, but if we need
> to keep it better make it explicit that axonram and dcssblk only support
> a sub-set of DAX due to missing _PAGE_DEVMAP support.

I sent a patch to remove axonram (sorry meant to Cc you):

  http://patchwork.ozlabs.org/patch/833588/

Will see if there's any feedback.

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
