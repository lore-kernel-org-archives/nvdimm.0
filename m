Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 193458209F
 for <linux-nvdimm@lists.01.org>; Sat, 11 Feb 2017 10:43:42 -0800 (PST)
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
 <CAPcyv4jA-H5CykS8A_JwGM635MJSa7Bj_G__eq9RwfjFCAke5Q@mail.gmail.com>
 <20170210201737.GA15397@kroah.com>
 <CAPcyv4gz0C+rhR=Xzk-G58yM=qpEBEuYbkushn5dByFD38KQbg@mail.gmail.com>
 <20170211071619.GA1345@kroah.com>
 <CAPcyv4gpeLehh6MgwWOd6=3UckOFNdGRR4jdKjq26+Jm5xijkg@mail.gmail.com>
 <c21c7b3d-81b8-d2ce-b5d0-42028984b93a@deltatee.com>
 <CAPcyv4hFBqVOJeWW0bqqV+vMVzTWnz3jOFi+kzDi=_xXBkTD1w@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <2358f952-5376-dd34-0694-6a27bc54f072@deltatee.com>
Date: Sat, 11 Feb 2017 11:43:33 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hFBqVOJeWW0bqqV+vMVzTWnz3jOFi+kzDi=_xXBkTD1w@mail.gmail.com>
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


On 11/02/17 11:27 AM, Dan Williams wrote:
> Why, when the lifetime of the cdev is already correct?

Well, it's only correct if you use the kobj parent trick which Greg is
arguing against. As someone reviewing/copying code that trick is
unclear, undocumented and it looks rather odd messing with internal
kobjects. Taking the explicit reference would be very clear, very
standard and only net one additional line.

> See commit ba09c01d2fa8 "dax: convert to the cdev api". I used to take
> explicit references like you suggest, but cdev made it cleaner.

I agree that, on the whole, that patch makes things a good deal cleaner.
I'm not so sure that this one small aspect is an improvement.

In any case, it's up to you. If you'd like I can certainly submit a v2
patch that adds the get/put.

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
