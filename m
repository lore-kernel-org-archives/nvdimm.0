Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7262F21BADAB2
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 12:33:36 -0700 (PDT)
Date: Fri, 27 Jul 2018 15:33:33 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 5/6] md/dm-writecache: Don't request pointer
 dummy_addr when not required
Message-ID: <20180727193333.GA23266@redhat.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
 <20180725162849.8320-6-yehs2007@zoho.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180725162849.8320-6-yehs2007@zoho.com>
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
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: jack@suse.cz, heiko.carstens@de.ibm.com, dm-devel@redhat.com, agk@redhat.com, linux-s390@vger.kernel.org, linux-nvdimm@lists.01.org, willy@infradead.org, bart.vanassche@wdc.com, chengnt@lenovo.com, colyli@suse.de, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 25 2018 at 12:28pm -0400,
Huaisheng Ye <yehs2007@zoho.com> wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> Function persistent_memory_claim doesn't need to get local pointer
> dummy_addr from direct_access. Using NULL instead of having to pass
> in a useless local pointer that caller then just throw away.
> 
> Suggested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
