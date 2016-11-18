Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wj0-x243.google.com (mail-wj0-x243.google.com
 [IPv6:2a00:1450:400c:c01::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BF8381E6E
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 02:22:49 -0800 (PST)
Received: by mail-wj0-x243.google.com with SMTP id xy5so39559wjc.1
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 02:22:54 -0800 (PST)
Date: Fri, 18 Nov 2016 13:22:51 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 02/20] mm: Use vmf->address instead of of
 vmf->virtual_address
Message-ID: <20161118102251.GB9430@node>
References: <1479460644-25076-1-git-send-email-jack@suse.cz>
 <1479460644-25076-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1479460644-25076-3-git-send-email-jack@suse.cz>
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

On Fri, Nov 18, 2016 at 10:17:06AM +0100, Jan Kara wrote:
> Every single user of vmf->virtual_address typed that entry to unsigned
> long before doing anything with it so the type of virtual_address does
> not really provide us any additional safety. Just use masked
> vmf->address which already has the appropriate type.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
