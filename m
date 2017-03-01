From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ndctl PATCH v2 2/3] ndctl: add a BTT check utility
Date: Wed, 1 Mar 2017 07:54:15 -0800
Message-ID: <CAPcyv4g+UfCR2x3KwWB+yu6fRh5UcVRvdAdrx3ri8bpJx+r8YQ@mail.gmail.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
 <20170222224724.7696-3-vishal.l.verma@intel.com>
 <x49a89610mr.fsf@segfault.boston.devel.redhat.com>
 <1488321002.4873.17.camel@intel.com>
 <x49inntt4z6.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <x49inntt4z6.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Mar 1, 2017 at 7:02 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>
>>> - Differentiate the use off BTT_PG_SIZE, sysconf(_SC_PAGESIZE), and
>>> SZ_4K
>>>   (for the fixed start offset) in the different places they're used
>>> (Jeff)
>>>
>>> I think you could go even further with this.  For example, you coud
>>> use
>>> BTT_START_OFFSET for the initial offset from the beginning of the raw
>>> namespace to the first btt info block.  Using the page size for the
>>> size
>>> of the info block is also less informative than it could be.  Instead,
>>> consider adding BTT_INFO_SIZE.  After that, all of your math starts to
>>> look a bit more readable to my eye.
>>
>> I thought of something along these lines, but ended up not doing this to
>> stay consistent with the 'BTT_PG_SIZE' usage in the kernel. But maybe
>> the kernel could use some cleaning up in this regard :)
>
> I obviously think it would look nicer.  ;-)  Anyway, it's not a blocker
> to get this series in.

So, my feedback was to store the offset in the bttc context so it's
just a property we carry and add unconditionally, it just might be
zero sometimes. Does that make things any cleaner?
