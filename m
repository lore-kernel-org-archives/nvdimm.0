From: Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/6] nfit, address-range-scrub: fix scrub in-progress
 reporting
Date: Fri, 6 Apr 2018 20:05:25 +0000
Message-ID: <MW2PR2101MB10346BA9D0C9C38ECC701D41FBBA0@MW2PR2101MB1034.namprd21.prod.outlook.com>
References: <152273077198.38372.11857145045474104173.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <152273077198.38372.11857145045474104173.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
To: Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 37b137ff8c83 nfit, libnvdimm: allow an ARS scrub to be triggered on demand.

The bot has also determined it's probably a bug fixing patch. (score: 97.4657)

The bot has tested the following trees: v4.16, v4.15.15, v4.14.32, v4.9.92.

v4.16: Build OK!
v4.15.15: Build OK!
v4.14.32: Build OK!
v4.9.92: Build OK!

--
Thanks,
Sasha
