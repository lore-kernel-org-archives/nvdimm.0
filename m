From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] util_namespace_to_json: fix potential null pointer
 dereference
Date: Thu, 23 Jun 2016 13:12:49 -0700
Message-ID: <CAPcyv4i9gPufyzCLcZi64Mh=1W-zv44D3vrEVqkOutw=JtXssA@mail.gmail.com>
References: <20160623195950.30968-1-jmoyer@redhat.com>
 <20160623195950.30968-2-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160623195950.30968-2-jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jun 23, 2016 at 12:59 PM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Coverity pointed out that "dax" could be NULL, and it goes unchecked.
>
> Signed-off-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  ndctl/util/json.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/ndctl/util/json.c b/ndctl/util/json.c
> index d144039..92e50fa 100644
> --- a/ndctl/util/json.c
> +++ b/ndctl/util/json.c
> @@ -133,6 +133,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
>                 jobj = json_object_new_string("memory");
>                 break;
>         case NDCTL_NS_MODE_DAX:
> +               if (!dax)
> +                       goto err;
>                 size = ndctl_dax_get_size(dax);
>                 jobj = json_object_new_string("dax");
>                 break;

The other patches look good, this one points out a problem with
ndctl_namespace_get_mode() which should be using a cached value rather
reading it from sysfs directly.  When we snapshot it with a cached
value it becomes impossible to have ndctl_namespace_get_mode() ==
NDCTL_NS_MODE_DAX and ndctl_namespace_get_dax() == NULL.
