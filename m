Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55F1F8204C
 for <linux-nvdimm@lists.01.org>; Fri, 10 Feb 2017 11:46:20 -0800 (PST)
Date: Fri, 10 Feb 2017 20:46:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] device-dax: don't set kobj parent during cdev init
Message-ID: <20170210194617.GA1803@kroah.com>
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1486754370-3057-1-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 10, 2017 at 12:19:30PM -0700, Logan Gunthorpe wrote:
> I copied this code and per feedback from Greg Kroah-Hartman [1] the
> cdev's kobject's parent should not be set to the related device.
> This should have minor consequences but isn't doing what anyone
> expects it to.
> 
> This patch then fixes device-dax so it doesn't make the same mistake.
> 
> [1] https://lkml.org/lkml/2017/2/10/370
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
