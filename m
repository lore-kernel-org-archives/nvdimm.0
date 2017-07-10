From: "Cheng-mean Liu (SOCCER)" <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] nvdimm: Remove minimum size requirement
Date: Mon, 10 Jul 2017 20:32:13 +0000
Message-ID: <MWHPR21MB0143A16C836BDD523C12A0EEA6A90@MWHPR21MB0143.namprd21.prod.outlook.com>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
 <20170710203012.GB22476@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170710203012.GB22476-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

I have tough time to image any scenarios that could make sense a zero-sized device.

-----Original Message-----
From: Matthew Wilcox [mailto:willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org] 
Sent: Monday, July 10, 2017 1:30 PM
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org; Cheng-mean Liu (SOCCER) <soccerl-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement

On Mon, Jul 10, 2017 at 11:41:08AM -0700, Dan Williams wrote:
> >         size = nvdimm_namespace_capacity(ndns);
> > -       if (size < ND_MIN_NAMESPACE_SIZE) {
> > -               dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
> > -                               &size, ND_MIN_NAMESPACE_SIZE);
> > +       if (size < PAGE_SIZE) {
> 
> If we're going to change the print level away from 'debug' then I 
> think this should be "if (size && size < PAGE_SIZE)". The sub-system 
> pre-creates 0-sized devices that are later configured into full 
> namespaces, in those cases we shouldn't fire the warning.

Should we allow drivers to claim zero-sized devices?  If not, then the
dev_warn() should be predicated on size being non-zero, but the return -ENODEV should still trigger.
