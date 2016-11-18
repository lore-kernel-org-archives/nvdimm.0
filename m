Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x241.google.com (mail-wm0-x241.google.com
 [IPv6:2a00:1450:400c:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A3A481E6E
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 02:22:08 -0800 (PST)
Received: by mail-wm0-x241.google.com with SMTP id g23so4645661wme.1
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 02:22:14 -0800 (PST)
Date: Fri, 18 Nov 2016 13:22:10 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 01/20] mm: Join struct fault_env and vm_fault
Message-ID: <20161118102210.GA9430@node>
References: <1479460644-25076-1-git-send-email-jack@suse.cz>
 <1479460644-25076-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1479460644-25076-2-git-send-email-jack@suse.cz>
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

On Fri, Nov 18, 2016 at 10:17:05AM +0100, Jan Kara wrote:
> Currently we have two different structures for passing fault information
> around - struct vm_fault and struct fault_env. DAX will need more
> information in struct vm_fault to handle its faults so the content of
> that structure would become event closer to fault_env. Furthermore it
> would need to generate struct fault_env to be able to call some of the
> generic functions. So at this point I don't think there's much use in
> keeping these two structures separate. Just embed into struct vm_fault
> all that is needed to use it for both purposes.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
