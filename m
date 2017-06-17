Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2313B21A143F1
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 17:50:07 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: RE: [PATCH v2] libnvdimm, pmem: Add sysfs notifications to badblocks
Date: Sat, 17 Jun 2017 00:51:21 +0000
Message-ID: <CS1PR84MB010409051553B970CAF4B9F482C60@CS1PR84MB0104.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170612222511.22030-1-toshi.kani@hpe.com>
 <CAPcyv4i03dU37tgqyRaMugGTqjagWeZ+WAtc7deJyZkkAbO9mA@mail.gmail.com>
 <CS1PR84MB0104A87F4AAB23AADF88656282C60@CS1PR84MB0104.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4geo4mhj9Ly9ro+uAS0kLNbeGgv+2eUQr1cZbJfhPKQMw@mail.gmail.com>
In-Reply-To: <CAPcyv4geo4mhj9Ly9ro+uAS0kLNbeGgv+2eUQr1cZbJfhPKQMw@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Fri, Jun 16, 2017 at 5:35 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> >> On Mon, Jun 12, 2017 at 3:25 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> >> > Sysfs "badblocks" information may be updated during run-time that:
> >> >  - MCE, SCI, and sysfs "scrub" may add new bad blocks
> >> >  - Writes and ioctl() may clear bad blocks
> >> >
> >> > Add support to send sysfs notifications to sysfs "badblocks" file
> >> > under region and pmem directories when their badblocks information
> >> > is re-evaluated (but is not necessarily changed) during run-time.
> >> >
> >> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> >> > Cc: Dan Williams <dan.j.williams@intel.com>
> >> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> >> > Cc: Linda Knippers <linda.knippers@hpe.com>
> >> > ---
> >> > v2: Send notifications for the clearing case
> >> > ---
> >>
> >> This looks good to me, I've applied it, but I also want to extend the
> >> ndctl unit tests to cover this mechanism.
> >
> > Right.  For the time being, would you mind to use the attached test
> > program for your sanity tests?  It simply monitors sysfs notifications
> > and prints badblocks info...  Sorry for inconvenience.
> >
> > Since I am not familiar with the ndctl unit tests and I am traveling for
> > the rest of the month, I may have to look into it after I am back.
> >
> 
> No worries, I'll take a look at integrating this. Have a nice trip!

Thanks Dan!!  I really appreciate it! 
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
