Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64EAC8209F
 for <linux-nvdimm@lists.01.org>; Sat, 11 Feb 2017 09:59:14 -0800 (PST)
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
 <CAPcyv4jA-H5CykS8A_JwGM635MJSa7Bj_G__eq9RwfjFCAke5Q@mail.gmail.com>
 <20170210201737.GA15397@kroah.com>
 <CAPcyv4gz0C+rhR=Xzk-G58yM=qpEBEuYbkushn5dByFD38KQbg@mail.gmail.com>
 <20170211071619.GA1345@kroah.com>
 <CAPcyv4gpeLehh6MgwWOd6=3UckOFNdGRR4jdKjq26+Jm5xijkg@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <c21c7b3d-81b8-d2ce-b5d0-42028984b93a@deltatee.com>
Date: Sat, 11 Feb 2017 10:59:04 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gpeLehh6MgwWOd6=3UckOFNdGRR4jdKjq26+Jm5xijkg@mail.gmail.com>
Subject: Re: [PATCH] device-dax: don't set kobj parent during cdev init
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On 11/02/17 01:56 AM, Dan Williams wrote:
> When the device is unregistered it invalidates all existing mappings,
> but the driver may continue to service vm fault requests until the
> final put of the cdev. Until that time the fault handler needs to be
> able to check dax_dev->alive. Since the final cdev put is handled by
> the vfs I use the cdev's kobject to keep the struct dax_dev instance
> alive.

I'm just taking a wild stab at this, but would it not make sense to just 
take a reference to the dax_dev device in dax_open and put it back it in 
dax_release? (Or perhaps, in the open/close of the vm_ops.) That way the 
structure won't be free'd until there are no users and alive will always 
be accessible.

It would also be a bit more clear as to what's going on because you are 
actually making a reference in filp->private_data.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
