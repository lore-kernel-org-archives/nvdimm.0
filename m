Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20161124091140.GB24138@quack2.suse.cz>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-3-git-send-email-ross.zwisler@linux.intel.com> <20161124091140.GB24138@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Nov 2016 11:42:38 -0800
Message-ID: <CAPcyv4g=4OAskS3x31H5yx0T+suDbpwQpSyDtb+36rwmKCGMng@mail.gmail.com>
Subject: Re: [PATCH 2/6] dax: remove leading space from labels
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 1:11 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 23-11-16 11:44:18, Ross Zwisler wrote:
>> No functional change.
>>
>> As of this commit:
>>
>> commit 218dd85887da (".gitattributes: set git diff driver for C source code
>> files")
>>
>> git-diff and git-format-patch both generate diffs whose hunks are correctly
>> prefixed by function names instead of labels, even if those labels aren't
>> indented with spaces.
>
> Fine by me. I just have some 4 remaining DAX patches (will send them out
> today) and they will clash with this. So I'd prefer if this happened after
> they are merged...

Let's just leave them alone, it's not like this thrash buys us
anything at this point.  We can just stop including spaces in new
code.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
