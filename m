From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: fsx tests on DAX started to fail with msync failure on 0307
 -next tree
Date: Tue, 14 Mar 2017 11:36:10 -0600
Message-ID: <20170314173609.GA13885@linux.intel.com>
References: <20170314025642.nwpf7zxbc6655gum@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170314025642.nwpf7zxbc6655gum@XZHOUW.usersys.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Mar 14, 2017 at 10:56:42AM +0800, Xiong Zhou wrote:
> Hi,
> 
> xfstests cases:
> generic/075 generic/112 generic/127 generic/231 generic/263
> 
> fail with DAX, pass without it. Both xfs and ext4.
> 
> It was okay on 0306 -next tree.

Thanks for the report.  I'm looking into it.  -next is all kinds of broken.
:(

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
