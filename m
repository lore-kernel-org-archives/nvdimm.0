Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC7242119623F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 14:58:11 -0700 (PDT)
Date: Mon, 11 Jun 2018 14:58:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v11 3/7] mm: fix __gup_device_huge vs unmap
Message-Id: <20180611145809.c05f215b9b2e7dab9e808304@linux-foundation.org>
In-Reply-To: <152669370864.34337.13815113039455146564.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152669369110.34337.14271778212195820353.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152669370864.34337.13815113039455146564.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, david@fromorbit.com, stable@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 18 May 2018 18:35:08 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> get_user_pages_fast() for device pages is missing the typical validation
> that all page references have been taken while the mapping was valid.
> Without this validation truncate operations can not reliably coordinate
> against new page reference events like O_DIRECT.
> 
> Cc: <stable@vger.kernel.org>

I'm not seeing anything in the changelog which justifies a -stable
backport.  ie: a description of the end-user-visible effects of the
bug?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
