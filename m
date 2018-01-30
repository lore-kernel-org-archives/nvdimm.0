Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6123B22364890
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jan 2018 15:44:43 -0800 (PST)
Date: Tue, 30 Jan 2018 16:50:18 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] libnvdimm, namespace: remove redundant initialization of
 'nd_mapping'
Message-ID: <20180130235018.GE23836@linux.intel.com>
References: <20180130174707.4921-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180130174707.4921-1-colin.king@canonical.com>
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
To: Colin King <colin.king@canonical.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 30, 2018 at 05:47:07PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer nd_mapping is being initialized to a value that is never read,
> instead it is being updated to a new value in all the cases where it
> is being read afterwards, hence the initialization is redundant and
> can be removed.
> 
> Cleans up clang warning:
> drivers/nvdimm/namespace_devs.c:2411:21: warning: Value stored to
> 'nd_mapping' during its initialization is never rea
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Sure, this looks good.  Thanks.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
