Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E57F21945DED
 for <linux-nvdimm@lists.01.org>; Mon,  5 Jun 2017 17:29:33 -0700 (PDT)
Date: Mon, 5 Jun 2017 18:30:36 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [resend RFC 1/6] ACPICA: add HMAT table definitions
Message-ID: <20170606003036.GA5997@linux.intel.com>
References: <20170602205956.28351-1-ross.zwisler@linux.intel.com>
 <20170605195057.31492-1-ross.zwisler@linux.intel.com>
 <20170605195057.31492-2-ross.zwisler@linux.intel.com>
 <CAJZ5v0iARt8WT+VHt21trSvYqqy6f4ExLEL3UVxJ4vbX_=_bcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iARt8WT+VHt21trSvYqqy6f4ExLEL3UVxJ4vbX_=_bcQ@mail.gmail.com>
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
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Box,, "Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, ACPI Devel Maling List" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, "devel@acpica.org" <devel@acpica.org>, "Kogut, Jaroslaw  <Jaroslaw.Kogut@intel.com>, Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lahtinen,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 05, 2017 at 10:44:11PM +0200, Rafael J. Wysocki wrote:
> On Mon, Jun 5, 2017 at 9:50 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > Import HMAT table definitions from the ACPICA codebase.
> >
> > This kernel patch was generated using an ACPICA patch from "Zheng, Lv"
> > <lv.zheng@intel.com>.  The actual upstream patch that adds these table
> > definitions will come from the Intel ACPICA team as part of their greater
> > ACPI 6.2 update.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Can you please hold on util we have integrated all of the pending
> ACPICA changes?

Sure, this is really just meant to spur discussion on the correct course.
Comments welcome (encouraged!) on the series as a whole and especially the
APIs needed by userspace, but ultimately patch 1 will be dropped and I'll just
build on the ACPICA definitions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
