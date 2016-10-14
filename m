Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 14 Oct 2016 14:31:47 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 05/20] mm: Trim __do_fault() arguments
Message-ID: <20161014203147.GD27575@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474992504-20133-6-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:08:09PM +0200, Jan Kara wrote:
> Use vm_fault structure to pass cow_page, page, and entry in and out of
> the function. That reduces number of __do_fault() arguments from 4 to 1.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

In looking at this I realized that vmf->entry is actually unused, as is the
entry we used to return back via __do_fault().  I guess they must have been in
there because at one point they were needed for dax_unlock_mapping_entry()?
Anyway, looking ahead I see patch 10 removes vmf->entry altogether. :)

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
