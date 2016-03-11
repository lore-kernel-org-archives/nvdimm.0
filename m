Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0DAD1A1F88
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 15:29:59 -0800 (PST)
Date: Fri, 11 Mar 2016 16:29:41 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v6 2/8] nvdimm: Add wrapper for IOCTL pass thru
Message-ID: <20160311232941.GA139754@tevye.fc.hp.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
 <833a627a8cff27a72f946fa9432cacf2a855e485.1457730736.git.jerry.hoemann@hpe.com>
 <CAPcyv4gBg5g2Zj6xE0RC0k68t+x8KY9zaJprRC4UYP3HAX3oew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gBg5g2Zj6xE0RC0k68t+x8KY9zaJprRC4UYP3HAX3oew@mail.gmail.com>
Reply-To: Jerry.Hoemann@hpe.com
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 11, 2016 at 02:04:04PM -0800, Dan Williams wrote:
> On Fri, Mar 11, 2016 at 1:16 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > +
> > +
> > +struct nd_cmd_pkg {
> > +       __u32   ncp_type;
> 
> I think 'family' is more clear, to signify the class of commands that
> the 'command' parameter references.


Oh, family of commands for a DSM.  I was thinking you wanted
family of DSM for a given nvdimm type which didn't seem quite
right.

I'll change.


>					 Also let's drop the ncp_ prefix,
> it's non-idiomatic with the rest of the definitions in this file.


I like field names with prefixes that refer back to the structure they're
defined in.  It makes reading code easier.  (e.g. how many times is
"size" defined in a struct?)

would you be okay with a prefix "nd_"?  it doesn't quite tie as closely
to the struct, but it should make them unique w/in the kernel.


> 
> > +       __u32   ncp_rev;
> 
> Why do we need a separate revision field?  A revision change
> effectively selects a different 'family' of commands, so I don't think
> we need to reflect that ACPI-specific aspect of the commands at this
> level.

 To be clear, if/when a DSM specification is extended in the future, with
 a new command added (all other commands remaining) and the revision to
 the DSM is incremented, you want to have a new family defined/used
 by the ioctl interface?

 I should be able to do this.



> 
> > +       __u64   ncp_command;
> > +       __u32   ncp_size_in;                    /* size of input payload */
> > +       __u32   ncp_size_out;                   /* size of user buffer   */
> 
> What's "user" in this context?  How about "/* size of output payload */"

Yes, a confusing name.

This is total space (including input portion) that the user
space caller has set aside for the output of the DSM call.

The kernel when copying out to user space will not exceed
the size given.

Need to convey that both of these are INPUT parameter the caller
is passing.


> 
> > +       __u32   ncp_reserved2[9];               /* reserved must be zero */
> > +       __u32   ncp_pot_size;                   /* potential output size */
> 
> It's not 'potential'' it's the 'actual' output size written by the
> kernel/firmware, right?


No, it is potential.

Going though multiple version of the spec, I would see dsm calls
where the amount of the data the dsm returned was not something that
the caller could know apriori.

So, the interface returns the amount of data that will fit in
the space provided and tell the user app in ncp_pot_size the
amount of data it wants to return.  If what the dsm call wants to
return fits in the space provided, it is what is written.  If what
the DSM would want to return is greater, it is the greater.

This allows for idempotent calls to be redone with appropriately
sized buffer.


This interface needs a man page.  :)

I will put a larger comment block in the next version.



> 
> > +       unsigned char ncp_payload[];            /* Contents of call      */
> > +};
> > +
> > +#define NCP_TYPE_BUS                   1
> > +#define NCP_TYPE_DIMM_INTEL1           2
> > +#define NCP_TYPE_DIMM_N_HPE1           3
> > +#define NCP_TYPE_DIMM_N_HPE2           4
> 
> s/NCP_TYPE_/ND_FAMILY_/

  Will do.

> 
> I think it would be helpful to put comments in the code here about
> where these families are defined.

  Will do.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
