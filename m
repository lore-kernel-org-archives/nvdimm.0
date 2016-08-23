From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
Date: Tue, 23 Aug 2016 13:42:16 -0700
Message-ID: <20160823134216.8f8e8944581fe1ae202377d1@linux-foundation.org>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1471977800-12688-1-git-send-email-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, m.abhilash-kumar-ZPxbGqLxI0U@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Starkey <brian.starkey-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, 23 Aug 2016 12:43:20 -0600 Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> The following BUG was observed while starting up KVM with nvdimm
> device as memory-backend-file to /dev/dax.
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>
> ...
>
> devm_memremap_pages() calls for_each_device_pfn() to walk through
> all pfns in page_map.  pfn_first(), however, returns a wrong pfn
> that leaves page->pgmap uninitialized.
> 
> Since arch_add_memory() has set up direct mappings to the NVDIMM
> range with altmap, pfn_first() should not modify the start pfn.
> Change pfn_first() to simply return pfn of res->start.

Which kernel version(s) do you think need fixing?
