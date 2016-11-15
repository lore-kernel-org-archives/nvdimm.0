Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x243.google.com (mail-wm0-x243.google.com
 [IPv6:2a00:1450:400c:c09::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4E0E81EDF
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 14:20:57 -0800 (PST)
Received: by mail-wm0-x243.google.com with SMTP id a20so4779824wme.2
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 14:21:02 -0800 (PST)
Date: Wed, 16 Nov 2016 01:20:55 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 08/21] mm: Allow full handling of COW faults in ->fault
 handlers
Message-ID: <20161115222055.GH23021@node>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-9-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1478233517-3571-9-git-send-email-jack@suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 04, 2016 at 05:25:04AM +0100, Jan Kara wrote:
> To allow full handling of COW faults add memcg field to struct vm_fault
> and a return value of ->fault() handler meaning that COW fault is fully
> handled and memcg charge must not be canceled. This will allow us to
> remove knowledge about special DAX locking from the generic fault code.
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
