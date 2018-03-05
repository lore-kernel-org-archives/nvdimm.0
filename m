Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D010B21E082BE
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 09:55:14 -0800 (PST)
Date: Mon, 5 Mar 2018 11:01:26 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] acpi, nfit: remove redundant __func__ in dev_dbg
Message-ID: <20180305180126.GB19268@linux.intel.com>
References: <20180302122049.13900-1-jthumshirn@suse.de>
 <20180305174920.GA19268@linux.intel.com>
 <CAPcyv4juD2m-4e7=uCy7P-retsTpWXJzVmO9fFcVbMcN_E=BXA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4juD2m-4e7=uCy7P-retsTpWXJzVmO9fFcVbMcN_E=BXA@mail.gmail.com>
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
Cc: Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 05, 2018 at 09:53:47AM -0800, Dan Williams wrote:
> On Mon, Mar 5, 2018 at 9:49 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Fri, Mar 02, 2018 at 01:20:49PM +0100, Johannes Thumshirn wrote:
> >> Dynamic debug can be instructed to add the function name to the debug
> >> output using the +f switch, so there is no need for the nfit module to
> >> do it again. If a user decides to add the +f switch for nfit's dynamic
> >> debug this results in double prints of the function name like the
> >> following:
> >>
> >> [ 2391.935383] acpi_nfit_ctl: nfit ACPI0012:00: acpi_nfit_ctl:nmem8 cmd: 10: func: 1 input length: 0
> >>
> >> Thus remove the stray __func__ printing.
> >>
> >> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> >
> > This makes sense to me, but I guess we'll see what Dan thinks.  If we decide
> > to go this route we may also want to do the same to all the instances of this
> > pattern in the libnvdimm debug output.
> 
> Is there a way to turn on this '+f' flag from the kernel boot command
> line? My primary debug scenario is specifying "libnvdimm.dyndbg
> nfit.dyndbg" on the command line.

Yep, it's just:

libnvdimm.dyndbg="+fp"
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
