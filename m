Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 545E281EE5
 for <linux-nvdimm@lists.01.org>; Sat, 11 Feb 2017 21:42:43 -0800 (PST)
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
 <CAPcyv4jA-H5CykS8A_JwGM635MJSa7Bj_G__eq9RwfjFCAke5Q@mail.gmail.com>
 <20170210201737.GA15397@kroah.com>
 <CAPcyv4gz0C+rhR=Xzk-G58yM=qpEBEuYbkushn5dByFD38KQbg@mail.gmail.com>
 <20170211071619.GA1345@kroah.com>
 <CAPcyv4gpeLehh6MgwWOd6=3UckOFNdGRR4jdKjq26+Jm5xijkg@mail.gmail.com>
 <c21c7b3d-81b8-d2ce-b5d0-42028984b93a@deltatee.com>
 <CAPcyv4hFBqVOJeWW0bqqV+vMVzTWnz3jOFi+kzDi=_xXBkTD1w@mail.gmail.com>
 <2358f952-5376-dd34-0694-6a27bc54f072@deltatee.com>
 <CAPcyv4g3KO8W0T9aNCB=Z40Zk4OF_SVz3jOb3fGfM6eE6M-VgA@mail.gmail.com>
 <CAPcyv4jdUZG1Kfn-t=f=YehPqPOiptEmg7CC_pP0TgmoHbKpLA@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <fc011745-b12d-7008-8638-8b0e50f6d8f9@deltatee.com>
Date: Sat, 11 Feb 2017 22:42:34 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jdUZG1Kfn-t=f=YehPqPOiptEmg7CC_pP0TgmoHbKpLA@mail.gmail.com>
Subject: Re: [PATCH] device-dax: don't set kobj parent during cdev init
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On 11/02/17 11:58 AM, Dan Williams wrote:
> Also when using an embedded cdev how would you recommend avoiding this problem?

I don't know. Hopefully, Greg has a good idea. But it sounds like a
general problem that a lot of cdev's actually suffer from without
realizing. Perhaps we need a more general solution. Some way for the
cdev to reference its containing structure in a way that it's designed
for such that anyone writing a driver will do the right thing without
needing to dive into the kobjects.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
