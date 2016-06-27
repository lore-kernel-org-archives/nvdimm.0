From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ndctl: delete duplicate -v on "ndctl destroy-namespace
 --help" page
Date: Mon, 27 Jun 2016 11:27:23 -0700
Message-ID: <CAPcyv4hFxMai5wPLhZL2vs+kPQ8M6H1uXZLaeHztHwaoy4RzNg@mail.gmail.com>
References: <1467025306-12846-1-git-send-email-yizhan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1467025306-12846-1-git-send-email-yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Jun 27, 2016 at 4:01 AM, Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> "ndctl destroy-namespace --help" page display below two -v option:
> [1]-v, --verbose
>         Emit debug messages for the namespace operation
> [2]-v, --verbose
>         Emit debug messages for the namespace destruction operation
>
> Delete the first one which included from xable-namespace-options.txt
>

Let's delete the second one so that if xable-namespace-options.txt
ever changes all dependent man pages get updated.
