Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22c.google.com (mail-it0-x22c.google.com
 [IPv6:2607:f8b0:4001:c0b::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E45E9202E5E58
 for <linux-nvdimm@lists.01.org>; Sat,  4 Nov 2017 09:27:57 -0700 (PDT)
Received: by mail-it0-x22c.google.com with SMTP id n195so825350itg.0
 for <linux-nvdimm@lists.01.org>; Sat, 04 Nov 2017 09:31:53 -0700 (PDT)
Subject: Re: [PATCH 04/15] brd: remove dax support
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949211688.24061.1197869674847507598.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <74de4b5f-eacd-9058-45e6-d7fcfb2f0d51@kernel.dk>
Date: Sat, 4 Nov 2017 10:31:51 -0600
MIME-Version: 1.0
In-Reply-To: <150949211688.24061.1197869674847507598.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 10/31/2017 05:21 PM, Dan Williams wrote:
> DAX support in brd is awkward because its backing page frames are
> distinct from the ones provided by pmem, dcssblk, or axonram. We need
> pfn_t_devmap() entries to fully support DAX, and the limited DAX support
> for pfn_t_special() page frames is not interesting for brd when pmem is
> already a superset of brd.  Lastly, brd is the only dax capable driver
> that may sleep in its ->direct_access() implementation. So it causes a
> global burden with no net gain of kernel functionality.
> 
> For all these reasons, remove DAX support.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
