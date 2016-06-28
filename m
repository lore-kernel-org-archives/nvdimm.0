Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 991031A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 08:32:02 -0700 (PDT)
Date: Tue, 28 Jun 2016 09:31:24 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] acpi, nfit: fix acpi_check_dsm() vs zero functions
 implemented
Message-ID: <20160628153124.GB82133@tevye.fc.hp.com>
References: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
 <bd2353c0-0d84-3c0a-8117-3f24b823f469@hpe.com>
 <CAPcyv4iELmJ9vDD7-juYOP4a6P51UFd49OUwreeofsXX7eHzCg@mail.gmail.com>
 <b877a201-6b62-43c6-17f8-dcaf5961cbb0@hpe.com>
 <CAPcyv4gWC4cND_+DUi_gjMpy2NLhNdhEfhwHjQ7x0AhKR0K7Vg@mail.gmail.com>
 <57724569.6020609@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57724569.6020609@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 28, 2016 at 05:37:45PM +0800, Xiao Guangrong wrote:
> 
> 
> On 06/28/2016 02:58 AM, Dan Williams wrote:
> > On Mon, Jun 27, 2016 at 11:47 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> > > 
> > > 
> > > On 6/27/2016 2:06 PM, Dan Williams wrote:
> > > > On Mon, Jun 27, 2016 at 10:40 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> > > > > 
> > > > > On 6/24/2016 1:44 PM, Dan Williams wrote:
> > > > > > QEMU 2.6 implements nascent support for nvdimm DSMs. Depending on
> > > > > > configuration it may only implement the function0 dsm to indicate that
> > > > > > no other DSMs are available. Commit 31eca76ba2fc "nfit, libnvdimm:
> > > > > > limited/whitelisted dimm command marshaling mechanism" breaks QEMU, but
> > > > > > QEMU is spec compliant.  Per the spec the way to indicate that no
> > > > > > functions are supported is:
> > > > > > 
> > > > > >      If Function Index is zero, the return is a buffer containing one bit
> > > > > >      for each function index, starting with zero. Bit 0 indicates whether
> > > > > >      there is support for any functions other than function 0 for the
> > > > > >      specified UUID and Revision ID. If set to zero, no functions are
> > > > > >      supported (other than function zero) for the specified UUID and
> > > > > >      Revision ID.
> > > > > 
> > > > > The rest of that paragraph is:
> > > > > 
> > > > > If set to one, at least one additional function is supported. For all other bits
> > > > > in the buffer, a bit is set to zero to indicate if that function index is not
> > > > > supported for the specific UUID and Revision ID. (For example, bit 1 set to 0
> > > > > indicates that function index 1 is not supported for the specific UUID and
> > > > > Revision ID.)
> > > > > 
> > > > > > 
> > > > > > Update the nfit driver to determine the family (interface UUID) without
> > > > > > requiring the implementation to define any other functions, i.e.
> > > > > > short-circuit acpi_check_dsm() to succeed per the spec.  The nfit driver
> > > > > > appears to be the only user passing funcs==0 to acpi_check_dsm(), so
> > > > > > this behavior change of the common routine should be limited to the
> > > > > > probing done by the nfit driver.
> > > > > 
> > > > > I don't understand why we're special casing this to support QEMU only when
> > > > > there are no DSM functions supported.  If we want to implement the
> > > > > spec and support function zero, I think we should support it correctly.
> > > > > That means returning the correct value for all spec compliant callers,
> > > > > even when there are functions that are supported.
> > > > 
> > > > QEMU 2.6 already shipped, so whatever we do we should not regress
> > > > those binaries.  The QEMU behavior could be argued as not spec
> > > > compliant, but they've implemented enough of function0 to answer the
> > > > "which family" probe.
> > > 
> > > How would you argue that?
> > 
> > acpi_evaluate_dsm() returns data instead of an error.
> > 
> > > > Yes, if an implementation supports function0 it
> > > > should say so in the returned bitmask,
> > > 
> > > But in other places you explicitly prevent function 0 from
> > > being executed.
> > 
> > Right, for the whitelist-filtered result to userspace, but this patch
> > is about the initial kernel probe.
> > 
> > > > but by the time we've
> > > > determined that function0 is "not supported" we've already
> > > > successfully executed a function0 request.
> > > 
> > > If they advertise a _DSM, I think they have to support function 0.
> > 
> > They should, but didn't.  Kernel v4.6 works with qemu 2.6, kernel v4.7
> > does not, so the kernel needs to be fixed.
> > 
> 
> Sorry.
> 
> I do not know why you guys think QEMU does not support function 0. It
> already returns 0 to indicates "no functions are supported
> (other than function zero)".
> 

  The currently upstream version of acpi_check_dsm doesn't handle this
  case,  it assumes at least one function other than zero is also being
  returned (as it assumes bit 0 is set.)

  Instead of the proposed change we should have something like:

index 22c0995..3ecf462 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -702,6 +702,9 @@ bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 funcs)
        if ((mask & 0x1) && (mask & funcs) == funcs)
                return true;
 
+       if ((mask == 0) && (funcs == 1))
+               return true;
+
        return false;
 }
 EXPORT_SYMBOL(acpi_check_dsm);


> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
