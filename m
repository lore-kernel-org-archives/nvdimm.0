Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x243.google.com (mail-lf0-x243.google.com
 [IPv6:2a00:1450:4010:c07::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E97F681CE2
 for <linux-nvdimm@lists.01.org>; Wed,  2 Nov 2016 03:02:33 -0700 (PDT)
Received: by mail-lf0-x243.google.com with SMTP id n3so668207lfn.0
 for <linux-nvdimm@lists.01.org>; Wed, 02 Nov 2016 03:02:35 -0700 (PDT)
Date: Wed, 2 Nov 2016 12:55:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 01/20] mm: Change type of vmf->virtual_address
Message-ID: <20161102095558.GA20724@node.shutemov.name>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <1478039794-20253-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1478039794-20253-2-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 01, 2016 at 11:36:07PM +0100, Jan Kara wrote:
> Every single user of vmf->virtual_address typed that entry to unsigned
> long before doing anything with it. So just change the type of that
> entry to unsigned long immediately.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
