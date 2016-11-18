Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x242.google.com (mail-wm0-x242.google.com
 [IPv6:2a00:1450:400c:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6342081E6E
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 02:23:49 -0800 (PST)
Received: by mail-wm0-x242.google.com with SMTP id m203so4604246wma.3
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 02:23:54 -0800 (PST)
Date: Fri, 18 Nov 2016 13:23:51 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 12/20] mm: Pass vm_fault structure into do_page_mkwrite()
Message-ID: <20161118102351.GC9430@node>
References: <1479460644-25076-1-git-send-email-jack@suse.cz>
 <1479460644-25076-13-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1479460644-25076-13-git-send-email-jack@suse.cz>
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

On Fri, Nov 18, 2016 at 10:17:16AM +0100, Jan Kara wrote:
> We will need more information in the ->page_mkwrite() helper for DAX to
> be able to fully finish faults there. Pass vm_fault structure to
> do_page_mkwrite() and use it there so that information propagates
> properly from upper layers.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
