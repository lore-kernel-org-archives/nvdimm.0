From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] mm: cleanup pfn_t usage in track_pfn_insert()
Date: Tue, 6 Sep 2016 13:30:19 -0700
Message-ID: <CAPcyv4idFA_QDpgHd0jgz_J=dBqDNRtBQuntXanJcaiNa-z9ww@mail.gmail.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318058712.30325.12749411762275637099.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160906132001.cd465767fa9844ddeb630cc4@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160906132001.cd465767fa9844ddeb630cc4-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Sep 6, 2016 at 1:20 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, 06 Sep 2016 09:49:47 -0700 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>> Now that track_pfn_insert() is no longer used in the DAX path, it no
>> longer needs to comprehend pfn_t values.
>
> What's the benefit in this?  A pfn *should* have type pfn_t, shouldn't
> it?   Confused.

It should when there's extra information to consider.  I don't mind
leaving it as is, but all the other usages of pfn_t are considering or
passing through the PFN_DEV and PFN_MAP flags.  So, it's a courtesy to
the reader saying "you don't need to worry about pfn_t defined
behavior here, this is just a plain old physical address >>
PAGE_SHIFT"
