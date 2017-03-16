From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: fsx tests on DAX started to fail with msync failure on 0307
 -next tree
Date: Thu, 16 Mar 2017 09:53:35 -0600
Message-ID: <20170316155335.GA27340@linux.intel.com>
References: <20170314025642.nwpf7zxbc6655gum@XZHOUW.usersys.redhat.com>
 <20170314173609.GA13885@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170314173609.GA13885-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Mar 14, 2017 at 11:36:10AM -0600, Ross Zwisler wrote:
> On Tue, Mar 14, 2017 at 10:56:42AM +0800, Xiong Zhou wrote:
> > Hi,
> > 
> > xfstests cases:
> > generic/075 generic/112 generic/127 generic/231 generic/263
> > 
> > fail with DAX, pass without it. Both xfs and ext4.
> > 
> > It was okay on 0306 -next tree.
> 
> Thanks for the report.  I'm looking into it.  -next is all kinds of broken.
> :(

Just FYI, in case folks are still testing -next:

One other issue that I was hitting was that for many of the commits in -next
kernel modules wouldn't load, which meant that my /dev/pmem0 device wasn't
showing up because I have libnvdimm compiled as a module.

I bisected that issue to this commit:

commit d1091c7fa3d5 ("objtool: Improve detection of BUG() and other dead
ends")

It looks like Xiong also found this issue:

https://lkml.org/lkml/2017/3/2/114

And Linus found it:

https://lkml.org/lkml/2017/2/28/794

- Ross
