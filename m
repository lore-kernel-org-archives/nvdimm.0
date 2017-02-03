Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <2020f442-8e77-cf14-a6b1-b4b00d0da80b@intel.com>
References: <201702040648.oOjnlEcm%fengguang.wu@intel.com> <2020f442-8e77-cf14-a6b1-b4b00d0da80b@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Feb 2017 15:26:55 -0800
Message-ID: <CAPcyv4hmswhXsnS9q1Ut76f3-a2h5Hx7XYkS1iNyak8wG9VuEw@mail.gmail.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Dave Jiang <dave.jiang@intel.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 3, 2017 at 3:25 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> On 02/03/2017 03:56 PM, kbuild test robot wrote:
>> Hi Dave,
>>
>> [auto build test ERROR on mmotm/master]
>> [cannot apply to linus/master linux/master v4.10-rc6 next-20170203]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> This one is a bit odd. I just pulled mmotm tree master branch and built
> with the attached .config and it passed for me (and I don't see this
> commit in the master branch). I also built linux-next with this patch on
> top and it also passes with attached .config. Looking at the err log
> below it seems the code has a mix of partial from before and after the
> patch. I'm rather confused about it....

This is a false positive. It tried to build it against latest mainline
instead of linux-next.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
