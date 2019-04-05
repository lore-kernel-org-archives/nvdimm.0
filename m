Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
 <20180125072351.GA11093@infradead.org> <20180125160802.GD10706@ziepe.ca>
 <20180125164750.GB31752@infradead.org> <CAPcyv4hi98RDD=F1rhumgCF+UiOisidmeAVrDePrTzF1ArXj4A@mail.gmail.com>
In-Reply-To: <CAPcyv4hi98RDD=F1rhumgCF+UiOisidmeAVrDePrTzF1ArXj4A@mail.gmail.com>
From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Fri, 5 Apr 2019 20:01:05 -0300
Message-ID: <CALEgSQvkUHLeS_7nBtrqoiEJ__Du4ZwZ4fFr_TSxZy-FhBWO-w@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, lsf-pc@lists.linux-foundation.org, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 26, 2018 at 10:50 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Jan 25, 2018 at 8:47 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Thu, Jan 25, 2018 at 09:08:02AM -0700, Jason Gunthorpe wrote:
> >> On Wed, Jan 24, 2018 at 11:23:51PM -0800, Christoph Hellwig wrote:
> >> > On Wed, Jan 24, 2018 at 07:56:02PM -0800, Dan Williams wrote:
> >> > > Particular people that would be useful to have in attendance are
> >> > > Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).
> >> >
> >> > I won't be able to make it - I'll have to do election work and
> >> > count the ballots for our city council and mayor election.
> >>
> >> I also have a travel conflict for that week in April and cannot make
> >> it.
> >
> > Are any of you going to be in the Bay Area in February for Usenix
> > FAST / LinuxFAST?
>
> I'll be around, but that said I still think it's worthwhile to have
> this conversation at LSF/MM. While we have a plan for filesystem-dax
> vs RDMA, there's still the open implications for the mm in other
> scenarios. I see Michal has also proposed this topic.

I also didn't make the cut for LSF/MM - is there some other conference
people will be at to discuss this intersection with RDMA, prior to
plumbers?

Jason
